locals {
  cluster = {
    # construct cluster from inventory.yml
    # mostly keeping their own original value
    # adding just deriviated fields
    for vmip, vm in yamldecode(file("./inventory.yml"))["cluster"]["hosts"] :
    vm["nodename"] => merge(vm, {
      ip_address       = vmip
      address          = "${vmip}/24"
      network_device   = vm["pve_network_device"]
      is_control_plane = contains(vm.roles, "control-plane")
    })
  }

  cluster_control_planes = { for k, v in local.cluster : k => v if v.is_control_plane }
}

data "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

data "external" "kubeadm_join_command" {
  program = ["bash", "${path.module}/get_join_command.sh"]

  query = {
    host     = values(local.cluster_control_planes)[0].ip_address
    ssh_user = "u"

    ssh_key_content = data.vault_kv_secret_v2.ci.data.id_rsa
  }
}

locals {
  kubeadm_join_command = data.external.kubeadm_join_command.result.join_command
}

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
  tags      = ["terraform", "k8s", "cobi"]

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
      password = random_password.vm_password.result
      username = "u"
      keys     = var.vm_authorized_keys
    }
  }

  connection {
    type        = "ssh"
    user        = "u"
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = each.value.ip_address
  }

  provisioner "file" {
    source      = "install-kube.sh"
    destination = "/tmp/install-kube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -euo pipefail",
      "export KUBERNETES_VERSION=${each.value.kubernetes_version}",
      "chmod +x /tmp/install-kube.sh",
      "/tmp/install-kube.sh",
      "sudo ${local.kubeadm_join_command} ${each.value.is_control_plane ? "--control-plane" : ""}"
    ]
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, disk[0].file_id]
  }
}
