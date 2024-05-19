resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "db" {
  node_name = var.proxmox_node.name
  vm_id     = 104
  name      = "db"
  tags      = ["terraform", "ubuntu"]


  cpu {
    cores        = 2
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
  }

  memory {
    dedicated = 4096
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = var.proxmox_node.storage_names[0].name
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 20
    backup       = true
    replicate    = false
  }

  disk {
    datastore_id = var.proxmox_node.storage_names[0].name
    interface    = "virtio1"
    size         = 20
    file_format  = "raw"
    backup       = true
    replicate    = false
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = var.proxmox_node.storage_names[0].name

    ip_config {
      ipv4 {
        address = "192.168.56.4/24"
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
}
