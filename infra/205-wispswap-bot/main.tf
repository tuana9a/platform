resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "wispswap_bot" {
  node_name = local.node_name
  vm_id     = 205
  name      = "wispswap-bot"
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
    datastore_id = local.storage.ssda
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 20
    backup       = true
    replicate    = false
  }

  disk {
    datastore_id = local.storage.ssda
    interface    = "virtio1"
    size         = 20
    file_format  = "raw"
    backup       = true
    replicate    = false
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = local.storage.ssda

    ip_config {
      ipv4 {
        address = "192.168.23.5/24"
        gateway = "192.168.23.1"
      }
    }

    user_account {
      keys     = var.vm_ssh_keys
      password = random_password.vm_password.result
      username = "u"
    }
  }

  network_device {
    bridge = "vmbr23"
  }

  on_boot = true
}
