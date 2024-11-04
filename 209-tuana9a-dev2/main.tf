resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "tuana9a_dev2" {
  node_name = local.proxmox_node.pve_cobi.node_name
  vm_id     = 209
  name      = "tuana9a-dev2"
  tags      = ["terraform", "ubuntu"]

  cpu {
    cores        = 4
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
  }

  memory {
    dedicated = 8192
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 64
    backup       = true
    replicate    = false
    speed {
      read            = 20
      read_burstable  = 25
      write           = 20
      write_burstable = 25
    }
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda

    ip_config {
      ipv4 {
        address = "192.168.56.209/24"
        gateway = "192.168.56.1"
      }
    }

    user_account {
      keys     = var.vm_ssh_keys
      password = random_password.vm_password.result
      username = "u"
    }
  }

  network_device {
    bridge = "vmbr56"
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization]
  }
}
