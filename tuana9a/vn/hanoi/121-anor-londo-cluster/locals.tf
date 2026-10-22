locals {
  vm_user     = "u"
  vm_password = random_password.vm_password.result
  key_file    = data.external.id_rsa.result.file_path
  vm_authorized_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx5LBYrl0TfkKChabUT6Fdwj40qr1eUCKBxIydmWOscQ+DlptTtN28PMmiIp6WAvYfQAD2lp5F6P1znFqqzKpKL/TFswfjdrbb0Br688jmzbeFAZ8cMDwJAEVxMi9P8Gkl5BxfTcVlrxyPdzfAjWps8DkZ8d8QkdKh6puAqfff1oN5/ubOOnSlvUL89VJmkE4jAuN1P5YTwYuz7mCP33LwBKltUqhLkGw5kKLz9MCF7GQ/9smH/1VKaBAsHMHx93ByISVU8zaVjbNfYE6vyHoDZUkLBZTtgksGZboyp8Rfj4+IBQVZ1xy9MiBQFMEAfNXEAHxD3QWNdRNGfNulqwvxeGNyja32gB+M4Ef4pybQ6KHDqW1aVOCqHLlGsQmMQN6E8HShZKQp9Fkq7kT+9e9LKDoJOem8Hb5E3xPD4umReogccJnHJCNuDQOM+Gfqlj1o4w+RTVA5ss6xsMGqUEdHBgoBYZZ2tgQYrIathq7V9+y0Yy3M4YZyEV9WyQI6HwU= u@tuana9a-dev2",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6bF/SOzb1XD4qo0LaZ5PVa1sCijDyQS/8oHZe9x6R5 ci",
  ]

  kubeadm_join_command = sensitive(data.external.get_join_command.result.join_command)

  _cluster = {
    # construct cluster from inventory.yml
    # mostly keeping their own original value
    # adding just deriviated fields
    for host_ip, host in yamldecode(file("./inventory.yml"))["cluster"]["hosts"] :
    host["nodename"] => merge(host, {
      ip_address               = host_ip
      address                  = "${host_ip}/24"
      network_device           = host["pve_network_device"]
      is_control_plane         = contains(host.roles, "control-plane") || contains(host.roles, "primary-control-plane")
      is_primary_control_plane = contains(host.roles, "primary-control-plane")
      is_the_first_upgrade     = contains(host.roles, "first-upgrade")
      kube_labels = [
        "topology.kubernetes.io/region=${host.pve_cluster}",
        "topology.kubernetes.io/zone=${host.pve_node}",
      ]
    })
  }

  cluster = { for k, v in local._cluster : k => v if v.create }

  cluster_control_planes = { for k, v in local.cluster : k => v if v.is_control_plane }
  cluster_kube_labels    = { for k, v in local.cluster : k => v.kube_labels }

  primary_control_plane      = one([for k, v in local.cluster : v if lookup(v, "is_primary_control_plane", false)])
  primary_control_plane_ip   = local.primary_control_plane.ip_address
  kubectl_label_nodes_script = join("\n", [for k, v in local.cluster_kube_labels : "kubectl label node ${k} ${join(" ", v)}"])
}
