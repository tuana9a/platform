resource "proxmox_virtual_environment_vm" "cluster_imported" {
  for_each  = local.vm_list_imported
  node_name = "xenomorph"
  vm_id     = each.value.vmid
  name      = "i-${each.value.vmid}"
  tags      = ["terraform", "k8s"]

  cpu {
    cores        = lookup(each.value, "corecount", 2)
    sockets      = 1
    architecture = "x86_64"
    flags        = []
    type         = "host"
  }

  memory {
    dedicated = lookup(each.value, "memsize", 4096)
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  disk {
    datastore_id      = "local"
    path_in_datastore = "${lookup(each.value, "template_vm_id", local.template_vm_id)}/base-${lookup(each.value, "template_vm_id", local.template_vm_id)}-disk-0.raw/${each.value.vmid}/vm-${each.value.vmid}-disk-0.qcow2"
    interface         = "scsi0"
    size              = lookup(each.value, "disksize", 32)
    speed {
      read            = 20
      read_burstable  = 50
      write           = 20
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
