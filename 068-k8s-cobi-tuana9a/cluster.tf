locals {
  cluster = {
    nodes = {
      i-122 = {
        vmid           = 122
        corecount      = 2
        memsize        = 4096
        vmip           = "192.168.56.22"
        address        = "192.168.56.22/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
      }
      i-124 = {
        vmid           = 124
        corecount      = 2
        memsize        = 4096
        vmip           = "192.168.56.24"
        address        = "192.168.56.24/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "engineer"
      }
      i-125 = {
        vmid           = 125
        corecount      = 2
        memsize        = 4096
        vmip           = "192.168.56.25"
        address        = "192.168.56.25/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "engineer"
      }
      i-131 = {
        vmid           = 131
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.31"
        address        = "192.168.56.31/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
        cloudimg       = "debian-12-generic-amd64-20251129-2311"
      }
      i-132 = {
        vmid           = 132
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.32"
        address        = "192.168.56.32/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "engineer"
      }
      i-134 = {
        vmid           = 134
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.34"
        address        = "192.168.56.34/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
      }
    }
  }
}

resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = local.cluster.nodes

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
    file_id      = "local:iso/${lookup(each.value, "cloudimg", "debian-12-generic-amd64-20250814-2204")}.img"
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
