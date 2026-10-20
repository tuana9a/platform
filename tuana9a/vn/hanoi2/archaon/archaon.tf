resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "hanoi2_archaon" {
  node_name = "engineer"
  vm_id     = 206
  name      = "hanoi2-archaon"
  tags      = ["terraform", "debian"]

  cpu {
    cores        = 4
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
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
    file_id      = "local:iso/debian-12-generic-amd64-20260510-2474.img"
    interface    = "virtio0"
    size         = 64
    backup       = true
    replicate    = false
    speed {
      read            = 20
      read_burstable  = 30
      write           = 20
      write_burstable = 30
    }
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = "192.168.56.206/24"
        gateway = "192.168.56.1"
      }
    }

    ip_config {
      ipv4 {
        address = "192.168.56.241/24"
      }
    }

    ip_config {
      ipv4 {
        address = "192.168.56.242/24"
      }
    }

    user_account {
      password = random_password.vm_password.result
      username = "ryuu"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0ommjJmg1FwFMvCMnBVsZDOTxmSXi3E6avR4NRVN/S coder@coder-tuana9a-gaia-0",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAMRhtFgdZzJJdRAurSda7caVOHz6msyWI3VzZC+0Ta ryuu@Phams-MacBook-Pro.local"
      ]
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
