resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each  = local.vm_list
  node_name = var.pve_node_name
  vm_id     = each.value.vmid
  name      = "i-${each.value.vmid}"
  tags      = ["terraform", "k8s"]

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
    file_id      = "local:iso/debian-12-generic-amd64-20250814-2204.img"
    interface    = "scsi0"
    size         = lookup(each.value, "disksize", 32)
    speed {
      read            = 30
      read_burstable  = 50
      write           = 30
      write_burstable = 50
    }
    backup    = true
    replicate = true
  }

  boot_order = ["scsi0"]

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

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = each.value.network_device
  }

  serial_device {
    device = "socket"
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
