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
        pve_node       = "engineer"
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
      }
      i-123 = {
        vmid           = 123
        corecount      = 2
        memsize        = 4096
        vmip           = "192.168.56.23"
        address        = "192.168.56.23/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "engineer"
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
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
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
      }
      # i-125 = {
      #   vmid           = 125
      #   corecount      = 2
      #   memsize        = 4096
      #   vmip           = "192.168.56.25"
      #   address        = "192.168.56.25/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "engineer"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
      # i-126 = {
      #   vmid           = 126
      #   corecount      = 2
      #   memsize        = 4096
      #   vmip           = "192.168.56.26"
      #   address        = "192.168.56.26/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "engineer"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
      # i-127 = {
      #   vmid           = 127
      #   corecount      = 2
      #   memsize        = 4096
      #   vmip           = "192.168.56.27"
      #   address        = "192.168.56.27/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "engineer"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
      i-131 = {
        vmid           = 131
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.31"
        address        = "192.168.56.31/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
      }
      i-132 = {
        vmid           = 132
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.32"
        address        = "192.168.56.32/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
      }
      i-133 = {
        vmid           = 133
        corecount      = 4
        memsize        = 12288
        vmip           = "192.168.56.33"
        address        = "192.168.56.33/24"
        gateway_ip     = "192.168.56.1"
        network_device = "vmbr0"
        pve_node       = "neomorph"
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
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
        cloudimg       = "debian-12-generic-amd64-20251129-2311.img"
      }
      # i-135 = {
      #   vmid           = 135
      #   corecount      = 4
      #   memsize        = 12288
      #   vmip           = "192.168.56.35"
      #   address        = "192.168.56.35/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "neomorph"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
      # i-136 = {
      #   vmid           = 136
      #   corecount      = 4
      #   memsize        = 12288
      #   vmip           = "192.168.56.36"
      #   address        = "192.168.56.36/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "neomorph"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
      # i-137 = {
      #   vmid           = 137
      #   corecount      = 4
      #   memsize        = 12288
      #   vmip           = "192.168.56.37"
      #   address        = "192.168.56.37/24"
      #   gateway_ip     = "192.168.56.1"
      #   network_device = "vmbr0"
      #   pve_node       = "neomorph"
      #   cloudimg       = "debian-12-generic-amd64-20250814-2204.img"
      # }
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

/*
https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/install.md#prepare-kubernetes-cluster

Proxmox CSI Plugin relies on the well-known Kubernetes topology node labels to define the disk location.
  topology.kubernetes.io/region - Cluster name, the name must be the same as in cloud config region name
  topology.kubernetes.io/zone - Proxmox node name

*/

locals {
  node_labels = [for key, node in local.cluster.nodes : ({
    nodename = key
    labels = [
      "topology.kubernetes.io/region=alien",
      "topology.kubernetes.io/zone=${node.pve_node}",
    ]
  })]
  node_labels_yaml = yamlencode(local.node_labels)
}

resource "local_file" "node_labels_yaml" {
  content  = local.node_labels_yaml
  filename = "${path.module}/files/generated/node_labels.yaml"
}
