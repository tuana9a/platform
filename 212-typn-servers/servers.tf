resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

locals {
  vms = {
    211 = {
      vmid    = 211
      vmip    = "192.168.56.211"
      memsize = 8192
    }
    212 = {
      vmid = 212
      vmip = "192.168.56.212"
    }
    213 = {
      vmid = 213
      vmip = "192.168.56.213"
    }
  }
}

resource "proxmox_virtual_environment_vm" "servers" {
  for_each  = local.vms
  node_name = var.pve_node_name
  vm_id     = each.value.vmid
  name      = "typn-${each.value.vmid}"
  tags      = ["terraform", "ubuntu"]

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = lookup(each.value, "memsize", 4096)
  }

  vga {
    clipboard = "vnc"
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 50
    backup       = false
    replicate    = false
    speed {
      read            = 50
      read_burstable  = 50
      write           = 50
      write_burstable = 50
    }
  }

  boot_order = ["virtio0"]

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = "${each.value.vmip}/24"
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
    # ignore_changes = [initialization, cpu[0].architecture]
  }
}
