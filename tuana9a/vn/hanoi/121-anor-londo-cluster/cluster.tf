locals {
  _cluster = {
    # construct cluster from inventory.yml
    # mostly keeping their own original value
    # adding just deriviated fields
    for host_ip, host in yamldecode(file("./inventory.yml"))["cluster"]["hosts"] :
    host["nodename"] => merge(host, {
      ip_address       = host_ip
      address          = "${host_ip}/24"
      network_device   = host["pve_network_device"]
      is_control_plane = contains(host.roles, "control-plane")
      kube_labels = [
        "topology.kubernetes.io/region=${host.pve_cluster}",
        "topology.kubernetes.io/zone=${host.pve_node}",
      ]
    })
  }

  cluster = { for k, v in local._cluster : k => v if v.create }

  cluster_control_planes = { for k, v in local.cluster : k => v if v.is_control_plane }
  cluster_kube_labels    = { for k, v in local.cluster : k => v.kube_labels }

  primary_control_plane_ip   = one([for k, v in local.cluster : v if lookup(v, "is_primary_control_plane", false)]).ip_address
  kubectl_label_nodes_script = join("\n", [for k, v in local.cluster_kube_labels : "kubectl label node ${k} ${join(" ", v)}"])

  vm_authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx5LBYrl0TfkKChabUT6Fdwj40qr1eUCKBxIydmWOscQ+DlptTtN28PMmiIp6WAvYfQAD2lp5F6P1znFqqzKpKL/TFswfjdrbb0Br688jmzbeFAZ8cMDwJAEVxMi9P8Gkl5BxfTcVlrxyPdzfAjWps8DkZ8d8QkdKh6puAqfff1oN5/ubOOnSlvUL89VJmkE4jAuN1P5YTwYuz7mCP33LwBKltUqhLkGw5kKLz9MCF7GQ/9smH/1VKaBAsHMHx93ByISVU8zaVjbNfYE6vyHoDZUkLBZTtgksGZboyp8Rfj4+IBQVZ1xy9MiBQFMEAfNXEAHxD3QWNdRNGfNulqwvxeGNyja32gB+M4Ef4pybQ6KHDqW1aVOCqHLlGsQmMQN6E8HShZKQp9Fkq7kT+9e9LKDoJOem8Hb5E3xPD4umReogccJnHJCNuDQOM+Gfqlj1o4w+RTVA5ss6xsMGqUEdHBgoBYZZ2tgQYrIathq7V9+y0Yy3M4YZyEV9WyQI6HwU= u@tuana9a-dev2",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6bF/SOzb1XD4qo0LaZ5PVa1sCijDyQS/8oHZe9x6R5 ci",
  ]

  kube_certs = [
    "/etc/kubernetes/pki/ca.crt",
    "/etc/kubernetes/pki/ca.key",
    "/etc/kubernetes/pki/sa.key",
    "/etc/kubernetes/pki/sa.pub",
    "/etc/kubernetes/pki/front-proxy-ca.crt",
    "/etc/kubernetes/pki/front-proxy-ca.key",
    "/etc/kubernetes/pki/etcd/ca.crt",
    "/etc/kubernetes/pki/etcd/ca.key",
  ]
}

data "external" "get_join_command" {
  program = ["bash", "${path.module}/get_join_command.sh"]

  query = {
    host     = local.primary_control_plane_ip
    ssh_user = local.vm_user

    key_file = local.key_file
  }
}

locals {
  kubeadm_join_command = sensitive(data.external.get_join_command.result.join_command)
}

data "external" "get_kube_certs" {
  program = concat(["bash", "${path.module}/get_kube_certs.sh"], local.kube_certs)

  query = {
    host     = local.primary_control_plane_ip
    ssh_user = local.vm_user
    key_file = local.key_file
  }
}

data "external" "variable_files" {
  program = ["bash", "./variable_files.sh"]
  query = merge(
    {
      vm_user                  = local.vm_user
      key_file                 = local.key_file
      primary_control_plane_ip = local.primary_control_plane_ip
    },
    { for k, v in local._cluster : "${k}_node_ip" => v.ip_address }
  )
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = { for k, v in local.cluster : k => v if v.create }

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
      username = local.vm_user
      keys     = local.vm_authorized_keys
    }

    upgrade = false
  }

  provisioner "local-exec" {
    when    = create
    command = "./wait_node_bootstrap_completed.sh ${local.key_file} ${local.vm_user} ${each.value.ip_address}"
  }

  provisioner "local-exec" {
    when    = create
    command = "./ssh_install_kube.sh ${local.key_file} ${local.vm_user} ${each.value.ip_address} ${each.value.kubernetes_version}"
  }

  # IDEA: bash script wait for a file how-to-scp-kube-certs.txt to be available -> the how to's file content will be multiple line, each line will be a map filepath -> remote file path
  provisioner "local-exec" {
    when    = create
    command = "./scp_kube_certs.sh ${local.key_file} ${local.vm_user} ${each.value.ip_address} ${each.value.is_control_plane ? 1 : 0}"
  }

  provisioner "local-exec" {
    when    = create
    command = "./kube_join.sh ${local.key_file} ${local.vm_user} ${each.value.ip_address} ${each.value.is_control_plane ? 1 : 0}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./drain_node.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./wait_node_detach_resources.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./kubeadm_reset.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./ssh_remove_etcd_member.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./delete_node.sh ${each.key}"
  }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, disk[0].file_id]
  }
}

resource "terraform_data" "cluster" {
  depends_on = [
    proxmox_virtual_environment_vm.cluster,
  ]

  triggers_replace = local.cluster_kube_labels

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.primary_control_plane_ip
  }

  # need to place the script setup here so that it will preserve the order of execution
  provisioner "file" {
    destination = "/tmp/kubectl_label_nodes.sh"
    content     = <<EOF
#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="$${KUBECONFIG:-/etc/kubernetes/admin.conf}"
${local.kubectl_label_nodes_script}
EOF
  }

  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "chmod +x /tmp/kubectl_label_nodes.sh && sudo /tmp/kubectl_label_nodes.sh",
    ]
  }
}
