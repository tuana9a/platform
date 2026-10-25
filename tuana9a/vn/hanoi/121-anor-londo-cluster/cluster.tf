resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = local.cluster

  node_name = each.value.pve_node
  vm_id     = each.value.vmid
  name      = "i-${each.value.vmid}"
  tags      = ["terraform"]

  cpu {
    cores   = lookup(each.value, "corecount", 2)
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = lookup(each.value, "memsize", 4096)
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/${each.value.cloudimg}"
    interface    = "scsi0"
    size         = lookup(each.value, "disksize", 32)
    speed {
      read            = 25
      read_burstable  = 25
      write           = 25
      write_burstable = 25
    }
    backup    = false
    replicate = false
  }

  operating_system {
    type = "l26"
  }

  boot_order = ["scsi0"]

  network_device {
    bridge = each.value.network_device
  }

  serial_device {
    device = "socket"
  }

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = each.value.address
        gateway = each.value.gateway_ip
      }
    }

    user_account {
      password = local.vm_password
      username = local.vm_user
      keys     = local.vm_authorized_keys
    }

    upgrade = false # dont upgrade during cloud-init
  }

  provisioner "local-exec" {
    when    = create
    command = "./scripts/node_ready_wait.sh"
    environment = {
      key_file = local.key_file
      ssh_user = local.vm_user
      node_ip  = each.value.ip_address
    }
  }

  provisioner "local-exec" {
    when    = create
    command = "./scripts/kube_install.sh ${each.value.kubernetes_version}"
    environment = {
      key_file = local.key_file
      ssh_user = local.vm_user
      node_ip  = each.value.ip_address
    }
  }

  provisioner "local-exec" {
    when = create
    # kube certs for control plane only
    command = (each.value.is_control_plane ? "./scripts/kube_certs_upload.sh" : "echo 'Skip kube certs upload as not control-plane'")
    environment = {
      key_file = local.key_file
      ssh_user = local.vm_user
      node_ip  = each.value.ip_address
    }
  }

  provisioner "local-exec" {
    when    = create
    command = "./scripts/kube_join.sh"
    environment = {
      key_file = local.key_file
      ssh_user = local.vm_user
      node_ip  = each.value.ip_address

      is_control_plane = "${each.value.is_control_plane ? 1 : 0}"
    }
  }

  provisioner "local-exec" {
    when = create
    command = (each.value.is_control_plane ? <<EOF
echo '${templatefile("./templates/kubevip.yaml", local.cluster[each.key].kubevip)}' | ssh -i $key_file -o StrictHostKeyChecking=no $ssh_user@$node_ip \
"sudo mkdir -p /etc/kubernetes/manifests && sudo tee /etc/kubernetes/manifests/kube-vip.yaml > /dev/null"
EOF
      : "echo 'Skip kubevip setup as not control-plane'"
    )
    environment = {
      key_file = local.key_file
      ssh_user = local.vm_user
      node_ip  = each.value.ip_address
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/kube_drain.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/node_resource_detached_wait.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/kube_reset.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/etcd_member_remove.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/kube_node_delete.sh ${each.key}"
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, disk[0].file_id]
  }
}
