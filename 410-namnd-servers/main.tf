resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

locals {
  vms = {
    410 = {
      vmid = 410
      vmip = "192.168.56.40"
    }
    411 = {
      vmid = 411
      vmip = "192.168.56.41"
    }
    412 = {
      vmid = 412
      vmip = "192.168.56.42"
    }
  }
}

resource "proxmox_virtual_environment_vm" "namnd_servers" {
  for_each  = local.vms
  node_name = "xenomorph"
  vm_id     = each.value.vmid
  name      = "namnd-${each.value.vmid}"
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
    datastore_id = "local"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 32
    backup       = true
    replicate    = false
    speed {
      read            = 20
      read_burstable  = 30
      write           = 20
      write_burstable = 30
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
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx5LBYrl0TfkKChabUT6Fdwj40qr1eUCKBxIydmWOscQ+DlptTtN28PMmiIp6WAvYfQAD2lp5F6P1znFqqzKpKL/TFswfjdrbb0Br688jmzbeFAZ8cMDwJAEVxMi9P8Gkl5BxfTcVlrxyPdzfAjWps8DkZ8d8QkdKh6puAqfff1oN5/ubOOnSlvUL89VJmkE4jAuN1P5YTwYuz7mCP33LwBKltUqhLkGw5kKLz9MCF7GQ/9smH/1VKaBAsHMHx93ByISVU8zaVjbNfYE6vyHoDZUkLBZTtgksGZboyp8Rfj4+IBQVZ1xy9MiBQFMEAfNXEAHxD3QWNdRNGfNulqwvxeGNyja32gB+M4Ef4pybQ6KHDqW1aVOCqHLlGsQmMQN6E8HShZKQp9Fkq7kT+9e9LKDoJOem8Hb5E3xPD4umReogccJnHJCNuDQOM+Gfqlj1o4w+RTVA5ss6xsMGqUEdHBgoBYZZ2tgQYrIathq7V9+y0Yy3M4YZyEV9WyQI6HwU= u@tuana9a-dev2"
      ]
    }
  }

  network_device {
    bridge = "vmbr56"
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
