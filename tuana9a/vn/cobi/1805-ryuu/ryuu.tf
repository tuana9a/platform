resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "ryuu" {
  node_name = "engineer"
  vm_id     = 1805
  name      = "ryuu"
  tags      = ["terraform", "ubuntu"]

  started = false

  cpu {
    cores        = 1
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
  }

  memory {
    dedicated = 2048
    floating  = 0
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  disk {
    datastore_id = "local"
    file_id      = "local:iso/noble-server-cloudimg-amd64.img"
    interface    = "virtio0"
    size         = 10
    backup       = false
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
        address = "192.168.56.185/24"
        gateway = "192.168.56.1"
      }
    }

    user_account {
      password = random_password.vm_password.result
      username = "u"
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQJOt5/MleT8q4xsWwYFMkv6pVJbT/emLge65lc3t3/bXko7UaKM1STRuFCWMhug/KFRe3WGYOTH9hTYtgsvm60FcCfORMxpnq0bej8d0k36sg0wG/dWfGFZ5IGLQSP78Sac9w8fPZrVtorGI59oLW83MqECDV/x134Rogsrm4q2NT+fhWi9X1G899vC1vqDE7u0nzWJcRMCjQcVy9FH+dRXl6eBX4msmtdIcn1mwDB9bBhAHseVH6d6CJvWxOXE9C/gGOAmcTmvgvL6G++yPUwmd/Uljxjf3uLZcVkA+YMaq5UQbPM6x+VLcEMXU+9uQSfqRUVHq8mL+BFJduMmoyK9QWZ9PZ2k8HSdRcLnQEq8h2DizAHt5khmC0hUKMr/7hHLE1ESpiWmq8rPxnqqjDkdUAj8EE1oKIZ51sveI6CXaJX2GuXGMnDpeB4MULa7bTfWHpQ/6qgobufjIO5m+C977PU2vLs9Tzr3ZSsASXTX4SidszLYKjh6rVjN+w60c= u@tuana9a-dev",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAMRhtFgdZzJJdRAurSda7caVOHz6msyWI3VzZC+0Ta ryuu@Phams-MacBook-Pro.local"
      ]
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  on_boot = true

  lifecycle {
    ignore_changes = [initialization, cpu[0].architecture]
  }
}
