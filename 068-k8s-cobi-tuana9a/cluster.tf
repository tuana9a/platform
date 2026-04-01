resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = local.cluster

  node_name = each.value.pve_node
  vm_id     = each.value.vmid
  name      = "i-${each.value.vmid}"
  tags      = ["terraform", "k8s", "cobi"]

  cpu {
    cores   = lookup(each.value, "corecount", 2)
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = lookup(each.value, "memsize", 4096)
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/${each.value.cloudimg}"
    interface    = "scsi0"
    size         = lookup(each.value, "disksize", 32)
    speed {
      read            = 25
      read_burstable  = 25
      write           = 25
      write_burstable = 25
    }
    backup    = false
    replicate = false
  }

  operating_system {
    type = "l26"
  }

  boot_order = ["scsi0"]

  network_device {
    bridge = each.value.network_device
  }

  serial_device {
    device = "socket"
  }

  initialization {
    datastore_id = "local"

    ip_config {
      ipv4 {
        address = each.value.address
        gateway = each.value.gateway_ip
      }
    }

    user_account {
      password = random_password.vm_password.result
      username = "u"
      keys     = var.vm_authorized_keys
    }
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization]
  }
}