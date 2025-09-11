resource "proxmox_virtual_environment_vm" "facehugger" {
  node_name = "xenomorph"
  vm_id     = 112
  name      = "facehugger"
  tags      = ["terraform"]

  cpu {
    cores   = 1
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/debian-12-generic-amd64-20250814-2204.img"
    interface    = "scsi0"
    size         = 12
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
        address = "192.168.56.12/24"
        gateway = "192.168.56.1"
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
    bridge = "vmbr56"
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
