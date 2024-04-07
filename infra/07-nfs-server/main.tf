resource "proxmox_virtual_environment_vm" "nfs" {
  name        = "nfs"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "nfs"]

  node_name = local.node_name
  vm_id     = 107

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
    datastore_id = local.storage_name
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 8
    backup       = false
    replicate    = false
  }

  disk {
    datastore_id = local.storage_name
    interface    = "virtio1"
    size         = 300
    file_format  = "raw"
    backup       = false
    replicate    = false
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = local.storage_name

    ip_config {
      ipv4 {
        address = "192.168.56.7/24"
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
