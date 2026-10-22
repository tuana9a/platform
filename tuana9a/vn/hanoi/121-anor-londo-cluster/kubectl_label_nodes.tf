resource "terraform_data" "kubectl_label_nodes" {
  depends_on = [
    proxmox_virtual_environment_vm.cluster,
  ]

  triggers_replace = local.kubectl_label_nodes_script

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = ephemeral.vault_kv_secret_v2.ci.data.id_rsa
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

  # NOTE: kubectl label node (required for csi-proxmox plugin working correctly)
  # https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/install.md#prepare-kubernetes-cluster
  # Proxmox CSI Plugin relies on the well-known Kubernetes topology node labels to define the disk location.
  #   topology.kubernetes.io/region - Cluster name, the name must be the same as in cloud config region name
  #   topology.kubernetes.io/zone - Proxmox node name
  provisioner "remote-exec" {
    inline = [
      "#!/usr/bin/env bash",
      "set -exuo pipefail",
      "chmod +x /tmp/kubectl_label_nodes.sh && sudo /tmp/kubectl_label_nodes.sh",
    ]
  }
}
