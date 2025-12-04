locals {
  servers = {
    211 = {
      vmid    = 211
      vmip    = "192.168.23.211"
      memsize = 8192
    }
    212 = {
      vmid    = 212
      vmip    = "192.168.23.212"
      memsize = 12288
    }
    213 = {
      vmid    = 213
      vmip    = "192.168.23.213"
      memsize = 12288
    }
  }
}

resource "random_password" "vm_password" {
  length  = 12
  special = false
}

resource "proxmox_virtual_environment_vm" "servers" {
  for_each = local.servers

  node_name = "engineer"
  vm_id     = each.value.vmid
  name      = "typn-${each.value.vmid}"
  tags      = ["terraform", "ubuntu", "typn"]

  cpu {
    cores   = lookup(each.value, "cores", 4)
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = lookup(each.value, "memsize", 4096)
  }

  network_device {
    bridge = "vmbr23"
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/jammy-server-cloudimg-amd64-20251125.img"
    interface    = "virtio0"
    size         = 50
    backup       = false
    replicate    = false
    speed {
      read            = 30
      read_burstable  = 30
      write           = 30
      write_burstable = 30
    }
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = "${each.value.vmip}/24"
        gateway = "192.168.23.1"
      }
    }

    user_account {
      password = random_password.vm_password.result
      username = "u"
      keys     = var.vm_authorized_keys
    }
  }

  vga {
    clipboard = "vnc"
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization]
  }
}
