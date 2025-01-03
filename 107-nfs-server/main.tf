resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "nfs_server" {
  node_name = local.proxmox_node.pve_cobi.node_name
  vm_id     = 107
  name      = "nfs-server"
  tags      = ["terraform"]

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
    size         = 20
    backup       = true
    replicate    = false
    speed {
      read            = 20
      read_burstable  = 30
      write           = 20
      write_burstable = 30
    }
  }

  disk {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda
    interface    = "virtio1"
    size         = 300
    file_format  = "raw"
    backup       = true
    replicate    = false
    speed {
      read            = 100
      read_burstable  = 200
      write           = 100
      write_burstable = 200
    }
  }

  # disk {
  #   datastore_id = local.proxmox_node.pve_cobi.storage.sdb
  #   interface    = "virtio2"
  #   size         = 300
  #   file_format  = "raw"
  #   backup       = true
  #   replicate    = false
  #   speed {
  #     read            = 50
  #     read_burstable  = 100
  #     write           = 50
  #     write_burstable = 100
  #   }
  # }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda

    ip_config {
      ipv4 {
        address = "192.168.56.7/24"
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
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
