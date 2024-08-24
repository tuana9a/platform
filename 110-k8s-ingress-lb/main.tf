resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "k8s_ingress_lb" {
  node_name = local.proxmox_node.pve_cobi.node_name
  vm_id     = 110
  name      = "k8s-ingress-lb"
  tags      = ["terraform", "ubuntu"]

  cpu {
    cores        = 1
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
  }

  memory {
    dedicated = 1024
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 10
    backup       = false
    replicate    = false
  }

  # boot_order = ["virtio0"]

  network_device {
    bridge = "vmbr56"
  }

  initialization {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda

    ip_config {
      ipv4 {
        address = "192.168.56.10/24"
        gateway = "192.168.56.1"
      }
    }

    user_account {
      keys     = var.vm_ssh_keys
      password = random_password.vm_password.result
      username = "u"
    }
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization]
  }
}
