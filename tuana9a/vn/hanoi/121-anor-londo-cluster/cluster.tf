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
    command = "key_file=${local.key_file} ssh_user=${local.vm_user} node_ip=${each.value.ip_address} ./scripts/wait_node_bootstrap_completed.sh"
  }

  provisioner "local-exec" {
    when    = create
    command = "key_file=${local.key_file} ssh_user=${local.vm_user} node_ip=${each.value.ip_address} ./scripts/install_kube.sh ${each.value.kubernetes_version}"
  }

  provisioner "local-exec" {
    when    = create
    command = "key_file=${local.key_file} ssh_user=${local.vm_user} node_ip=${each.value.ip_address} ./scripts/scp_kube_certs.sh ${each.value.is_control_plane ? 1 : 0}"
  }

  provisioner "local-exec" {
    when    = create
    command = "key_file=${local.key_file} ssh_user=${local.vm_user} node_ip=${each.value.ip_address} ./scripts/join_node.sh ${each.value.is_control_plane ? 1 : 0}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/drain_node.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/wait_node_detach_resources.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/reset_kubeadm.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/remove_etcd_member.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/delete_node.sh ${each.key}"
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, disk[0].file_id]
  }
}

resource "terraform_data" "post_cluster_setup" {
  depends_on = [
    proxmox_virtual_environment_vm.cluster,
  ]

  triggers_replace = sha256(jsonencode(local.cluster))

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  # need to place the script setup here so that it will preserve the order of execution
  provisioner "file" {
    destination = "/tmp/kubectl_label_nodes.sh"
    content     = <<EOF
#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="$${KUBECONFIG:-/etc/kubernetes/admin.conf}"
${local.kubectl_label_nodes_script}
EOF
  }

  # NOTE: kubectl label node (required for csi-proxmox plugin working correctly)
  # https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/install.md#prepare-kubernetes-cluster
  # Proxmox CSI Plugin relies on the well-known Kubernetes topology node labels to define the disk location.
  #   topology.kubernetes.io/region - Cluster name, the name must be the same as in cloud config region name
  #   topology.kubernetes.io/zone - Proxmox node name
  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "chmod +x /tmp/kubectl_label_nodes.sh && sudo /tmp/kubectl_label_nodes.sh",
    ]
  }
}
