resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "johnathan724_dev" {
  node_name = "neomorph"
  vm_id     = 214
  name      = "johnathan724-dev"
  tags      = ["terraform", "ubuntu"]

  cpu {
    cores   = 2
    sockets = 1
    flags   = []
    type    = "host"
  }

  memory {
    dedicated = 8192
    floating  = 0
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 100
    backup       = true
    replicate    = false
    speed {
      read            = 50
      read_burstable  = 75
      write           = 50
      write_burstable = 75
    }
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = "192.168.56.214/24"
        gateway = "192.168.56.1"
      }
    }

    user_account {
      password = random_password.vm_password.result
      username = "u"
      keys     = var.vm_authorized_keys
    }
  }

  network_device {
    bridge = "vmbr56"
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
