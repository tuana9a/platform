resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "nfs" {
  node_name = local.proxmox_node.pve_cobi.node_name
  vm_id     = 107
  name      = "nfs"
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
    datastore_id = local.proxmox_node.pve_cobi.storage.sda
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 8
    backup       = true
    replicate    = false
  }

  disk {
    datastore_id = local.proxmox_node.pve_cobi.storage.sda
    interface    = "virtio1"
    size         = 100
    file_format  = "raw"
    backup       = true
    replicate    = false
  }

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
    ignore_changes = [initialization]
  }
}
