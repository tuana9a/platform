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

  first_control_plane_ip     = values(local.cluster_control_planes)[0].ip_address
  kubectl_label_nodes_script = join("\n", [for k, v in local.cluster_kube_labels : "kubectl label node ${k} ${join(" ", v)}"])

  vm_authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx5LBYrl0TfkKChabUT6Fdwj40qr1eUCKBxIydmWOscQ+DlptTtN28PMmiIp6WAvYfQAD2lp5F6P1znFqqzKpKL/TFswfjdrbb0Br688jmzbeFAZ8cMDwJAEVxMi9P8Gkl5BxfTcVlrxyPdzfAjWps8DkZ8d8QkdKh6puAqfff1oN5/ubOOnSlvUL89VJmkE4jAuN1P5YTwYuz7mCP33LwBKltUqhLkGw5kKLz9MCF7GQ/9smH/1VKaBAsHMHx93ByISVU8zaVjbNfYE6vyHoDZUkLBZTtgksGZboyp8Rfj4+IBQVZ1xy9MiBQFMEAfNXEAHxD3QWNdRNGfNulqwvxeGNyja32gB+M4Ef4pybQ6KHDqW1aVOCqHLlGsQmMQN6E8HShZKQp9Fkq7kT+9e9LKDoJOem8Hb5E3xPD4umReogccJnHJCNuDQOM+Gfqlj1o4w+RTVA5ss6xsMGqUEdHBgoBYZZ2tgQYrIathq7V9+y0Yy3M4YZyEV9WyQI6HwU= u@tuana9a-dev2",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6bF/SOzb1XD4qo0LaZ5PVa1sCijDyQS/8oHZe9x6R5 ci",
  ]
}

# data "external" "kube_certs" {
#   program = ["bash", "${path.module}/get_kubeadm_certs.sh"]

#   query = {
#     host     = local.first_control_plane_ip
#     ssh_user = local.vm_username

#     ssh_key_content = data.vault_kv_secret_v2.ci.data.id_rsa
#   }
# }

resource "proxmox_virtual_environment_vm" "cluster" {
  depends_on = [
    local_sensitive_file.ci,
    local_file.wait_for_ssh,
    local_file.install_kube,
    local_sensitive_file.kube_join,
    local_file.drain_node,
    local_file.wait_node,
    local_file.delete_node,
  ]

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
      username = local.vm_username
      keys     = local.vm_authorized_keys
    }
  }

  provisioner "local-exec" {
    when    = create
    command = "./tmp/wait_for_ssh_${each.key}.sh"
  }

  provisioner "local-exec" {
    when    = create
    command = "./tmp/wait_for_cloud_init_${each.key}.sh"
  }

  # TODO: wait for cloud-init to be completed

  provisioner "local-exec" {
    when    = create
    command = "./tmp/install_kube_${each.key}.sh"
  }

  provisioner "local-exec" {
    when    = create
    command = "./tmp/kube_join_${each.key}.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./tmp/drain_node.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./tmp/wait_node.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./tmp/delete_node.sh ${each.key}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./tmp/kubeadm_reset_${each.key}.sh"
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
    terraform_data.control_plane_scripts,
  ]

  triggers_replace = local.cluster_kube_labels

  connection {
    type        = "ssh"
    user        = local.vm_username
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.first_control_plane_ip
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
