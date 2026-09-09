resource "terraform_data" "control_plane_scripts" {
  triggers_replace = timestamp()

  for_each = {
    drain_node = {
      destination = "/tmp/drain_node.sh"
      content     = <<EOF
#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="/etc/kubernetes/admin.conf"
sudo -E kubectl drain $1 --ignore-daemonsets --delete-emptydir-data --disable-eviction --force
EOF
    }
    delete_node = {
      destination = "/tmp/delete_node.sh"
      content     = <<EOF
#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="/etc/kubernetes/admin.conf"
sudo -E kubectl delete node $1
EOF
    }
    wait_for_empty_volumeattachments = {
      destination = "/tmp/wait_for_empty_volumeattachments.sh"
      content     = file("./wait_for_empty_volumeattachments.sh")
    }
  }

  connection {
    type        = "ssh"
    user        = local.vm_username
    private_key = data.vault_kv_secret_v2.ci.data.id_rsa
    host        = local.first_control_plane_ip
  }

  provisioner "file" {
    destination = each.value.destination
    content     = each.value.content
  }

  provisioner "remote-exec" {
    inline = ["chmod +x ${each.value.destination}"]
  }
}
