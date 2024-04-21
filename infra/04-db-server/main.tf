resource "proxmox_virtual_environment_vm" "db" {
  name = "db"
  tags = ["terraform", "ubuntu", "db"]

  node_name = local.node_name
  vm_id     = 104

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
    datastore_id = local.storage.local
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 8
    backup       = false
    replicate    = false
  }

  disk {
    datastore_id = local.storage.local
    interface    = "virtio1"
    size         = 20
    file_format  = "raw"
    backup       = false
    replicate    = false
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = local.storage.local

    ip_config {
      ipv4 {
        address = "192.168.56.4/24"
        gateway = "192.168.56.1"
      }
    }

    user_account {
      keys     = local.ssh_keys
      password = "1"
      username = "u"
    }
  }

  network_device {
    bridge = "vmbr56"
  }

  on_boot = true
}
