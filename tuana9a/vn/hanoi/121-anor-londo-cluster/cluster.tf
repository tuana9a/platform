locals {
  vm_username = "u"

  cluster = {
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

  cluster_control_planes = { for k, v in local.cluster : k => v if v.is_control_plane }
  cluster_kube_labels    = { for k, v in local.cluster : k => v.kube_labels }

  first_control_plane_ip     = values(local.cluster_control_planes)[0].ip_address
  kubectl_label_nodes_script = join("\n", [for k, v in local.cluster_kube_labels : "kubectl label node ${k} ${join(" ", v)}"])
}

data "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

data "external" "kubeadm_join_command" {
  program = ["bash", "${path.module}/get_join_command.sh"]

  query = {
    host     = local.first_control_plane_ip
    ssh_user = local.vm_username

    ssh_key_content = data.vault_kv_secret_v2.ci.data.id_rsa
  }
}

# data "external" "kube_certs" {
#   program = ["bash", "${path.module}/get_kubeadm_certs.sh"]

#   query = {
#     host     = local.first_control_plane_ip
#     ssh_user = local.vm_username

#     ssh_key_content = data.vault_kv_secret_v2.ci.data.id_rsa
#   }
# }

locals {
  kubeadm_join_command = data.external.kubeadm_join_command.result.join_command
}

resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = local.cluster

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
      keys     = var.vm_authorized_keys
    }
  }

  connection {
    type        = "ssh"
    user        = local.vm_username
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = each.value.ip_address
  }

  provisioner "file" {
    source      = "install-kube.sh"
    destination = "/tmp/install-kube.sh"
  }

  provisioner "file" {
    content     = <<EOF
#!/bin/bash

set -euo pipefail

export KUBERNETES_VERSION=${each.value.kubernetes_version}
chmod +x /tmp/install-kube.sh && /tmp/install-kube.sh
sudo ${local.kubeadm_join_command} ${each.value.is_control_plane ? "--control-plane" : ""}
EOF
    destination = "/tmp/kube-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -euo pipefail",
      "chmod +x /tmp/kube-setup.sh && /tmp/kube-setup.sh",
    ]
  }

  #   provisioner "local-exec" {
  #     command = <<EOF
  # #!/usr/bin/env bash
  # set -euo pipefail

  # # Write the key content to a temp file - ssh requires a file, not inline content
  # KEY_FILE=$(mktemp)
  # trap 'rm -f "$${KEY_FILE}"' EXIT

  # printf '%s\n' "${data.vault_kv_secret_v2.ci.data.id_rsa}" > "$${KEY_FILE}"
  # chmod 600 "$${KEY_FILE}"

  # ssh -o StrictHostKeyChecking=no \
  # -i "$${KEY_FILE}" \
  # "${local.vm_username}@${each.value.ip_address}"
  # EOF
  #   }

  on_boot = true

  reboot_after_update = false

  lifecycle {
    ignore_changes = [initialization, disk[0].file_id]
  }
}

resource "terraform_data" "post_cluster_setup" {
  triggers_replace = local.cluster_kube_labels

  connection {
    type        = "ssh"
    user        = local.vm_username
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.first_control_plane_ip
  }

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
