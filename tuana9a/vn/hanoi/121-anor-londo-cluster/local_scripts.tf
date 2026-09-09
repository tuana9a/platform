locals {
  local_scripts_dir = "./tmp"
}

resource "local_sensitive_file" "ci" {
  filename        = "${local.local_scripts_dir}/id_rsa"
  file_permission = "0600"
  content         = data.vault_kv_secret_v2.ci.data.id_rsa
}

resource "local_file" "wait_for_ssh" {
  for_each = local.cluster

  filename        = "${local.local_scripts_dir}/wait_for_ssh_${each.key}.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

TIMEOUT=300
INTERVAL=5

SSH_OPTS=(
  -o StrictHostKeyChecking=no
)

echo "Waiting for SSH on ${local.vm_username}@${each.value.ip_address} (timeout: $${TIMEOUT}s)..."

start_time=$(date +%s)

while true; do
  if ssh "$${SSH_OPTS[@]}" "${local.vm_username}@${each.value.ip_address}" true 2>/dev/null; then
    echo "SSH is up on ${each.value.ip_address}"
    exit 0
  fi

  now=$(date +%s)
  elapsed=$(( now - start_time ))
  if (( elapsed >= TIMEOUT )); then
    echo "Timed out after $${TIMEOUT}s waiting for SSH on ${each.value.ip_address}" >&2
    exit 1
  fi

  sleep "$INTERVAL"
done
EOF
}

resource "local_file" "wait_for_cloud_init" {
  for_each = local.cluster

  filename        = "${local.local_scripts_dir}/wait_for_cloud_init_${each.key}.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

TIMEOUT=300
INTERVAL=5

SSH_OPTS=(
  -o StrictHostKeyChecking=no
)

echo "==> Waiting for cloud-init on ${local.vm_username}@${each.value.ip_address} to finish..."
ssh "$${SSH_OPTS[@]}" "${local.vm_username}@${each.value.ip_address}" "cloud-init status --wait"
echo "cloud-init done. Node ${each.value.ip_address} is ready for provisioning."
EOF
}

resource "local_file" "install_kube" {
  for_each = local.cluster

  filename        = "${local.local_scripts_dir}/install_kube_${each.key}.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

scp -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  ./install-kube.sh ${local.vm_username}@${each.value.ip_address}:/tmp/install-kube.sh

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${each.value.ip_address}" \
  "set -euo pipefail; chmod +x /tmp/install-kube.sh && sudo KUBERNETES_VERSION=${each.value.kubernetes_version} /tmp/install-kube.sh"
EOF
}

resource "local_sensitive_file" "kube_join" {
  for_each = local.cluster

  filename        = "${local.local_scripts_dir}/kube_join_${each.key}.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${each.value.ip_address}" \
  "set -euo pipefail; sudo ${local.kubeadm_join_command} ${each.value.is_control_plane ? "--control-plane" : ""}"
EOF
}

resource "local_file" "drain_node" {
  filename        = "${local.local_scripts_dir}/drain_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${local.first_control_plane_ip}" \
  "set -euo pipefail; /tmp/drain_node.sh $1"
EOF
}

resource "local_file" "wait_node" {
  filename        = "${local.local_scripts_dir}/wait_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${local.first_control_plane_ip}" \
  "set -euo pipefail; /tmp/wait_for_empty_volumeattachments.sh $1"
EOF
}

resource "local_file" "delete_node" {
  filename        = "${local.local_scripts_dir}/delete_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${local.first_control_plane_ip}" \
  "set -euo pipefail; /tmp/delete_node.sh $1"
EOF
}

resource "local_file" "kubeadm_reset" {
  for_each = local._cluster

  filename        = "${local.local_scripts_dir}/kubeadm_reset_${each.key}.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

ssh -o StrictHostKeyChecking=no \
  -i "${local_sensitive_file.ci.filename}" \
  "${local.vm_username}@${each.value.ip_address}" \
  "set -euo pipefail; sudo kubeadm reset -f"
EOF
}
