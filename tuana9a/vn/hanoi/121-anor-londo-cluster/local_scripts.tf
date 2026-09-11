locals {
  local_scripts_dir = "./tmp"
}

resource "local_sensitive_file" "ci" {
  filename        = "${local.local_scripts_dir}/id_rsa"
  file_permission = "0600"
  content         = data.vault_kv_secret_v2.ci.data.id_rsa
}

resource "local_file" "wait_for_ssh" {
  filename        = "${local.local_scripts_dir}/wait_for_ssh.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_ip=$1

TIMEOUT=500
INTERVAL=5

SSH_OPTS=(
  -o StrictHostKeyChecking=no
)

echo "Waiting for SSH on ${local.vm_username}@$node_ip (timeout: $${TIMEOUT}s)..."

start_time=$(date +%s)

while true; do
  if ssh "$${SSH_OPTS[@]}" "${local.vm_username}@$node_ip" true 2>/dev/null; then
    echo "SSH is up on $node_ip"
    exit 0
  fi

  now=$(date +%s)
  elapsed=$(( now - start_time ))
  if (( elapsed >= TIMEOUT )); then
    echo "Timed out after $${TIMEOUT}s waiting for SSH on $node_ip" >&2
    exit 1
  fi

  sleep "$INTERVAL"
done
EOF
}

resource "local_file" "wait_for_cloud_init" {
  filename        = "${local.local_scripts_dir}/wait_for_cloud_init.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_ip=$1

TIMEOUT=300
INTERVAL=5

SSH_OPTS=(
  -o StrictHostKeyChecking=no
)

echo "==> Waiting for cloud-init on ${local.vm_username}@$node_ip to finish..."
ssh "$${SSH_OPTS[@]}" "${local.vm_username}@$node_ip" "cloud-init status --wait"
echo "cloud-init done. Node $node_ip is ready for provisioning."
EOF
}

resource "local_sensitive_file" "kube_certs" {
  for_each = data.external.get_kube_certs.result

  filename        = "${local.local_scripts_dir}/${replace(each.key, "/\\/|\\./", "_")}"
  file_permission = "0600"
  content_base64  = each.value
}

resource "local_file" "scp_kube_certs" {
  filename        = "${local.local_scripts_dir}/scp_kube_certs.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_ip=$1
is_control_plane=$2

if [[ "$is_control_plane" != "1" ]]; then
  echo "Not control plane, skipping..." 
  exit 0
fi

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

${join("\n", [for k, v in local_sensitive_file.kube_certs : "scp $${SSH_OPTS[@]} ${v.filename} ${local.vm_username}@$node_ip:/tmp/${basename(v.filename)}"])}
${join("\n", [for k, v in local_sensitive_file.kube_certs : "ssh $${SSH_OPTS[@]} ${local.vm_username}@$node_ip \"sudo mkdir -p ${dirname(k)} && sudo chmod 0755 ${dirname(k)}\""])}
${join("\n", [for k, v in local_sensitive_file.kube_certs : "ssh $${SSH_OPTS[@]} ${local.vm_username}@$node_ip \"sudo mv /tmp/${basename(v.filename)} ${k} && sudo chmod 0644 ${k}\""])}
EOF
}

resource "local_file" "install_kube" {
  filename        = "${local.local_scripts_dir}/install_kube.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_ip=$1
kubernetes_version=$2
SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

scp $${SSH_OPTS[@]} ./install-kube.sh ${local.vm_username}@$node_ip:/tmp/install-kube.sh

ssh $${SSH_OPTS[@]} "${local.vm_username}@$node_ip" \
  "set -euo pipefail; chmod +x /tmp/install-kube.sh && sudo KUBERNETES_VERSION=$kubernetes_version /tmp/install-kube.sh"
EOF
}

resource "local_sensitive_file" "kube_join" {
  filename        = "${local.local_scripts_dir}/kube_join.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_ip=$1
is_control_plane=$2
JOIN_OPTS=""
if [[ "$is_control_plane" == "1" ]]; then
  JOIN_OPTS+="--control-plane"
fi

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

ssh $${SSH_OPTS[@]} "${local.vm_username}@$node_ip" \
  "set -euo pipefail; sudo ${local.kubeadm_join_command} $JOIN_OPTS"
EOF
}

resource "local_file" "drain_node" {
  filename        = "${local.local_scripts_dir}/drain_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

ssh $${SSH_OPTS[@]} "${local.vm_username}@${local.primary_control_plane_ip}" \
  "set -euo pipefail; /tmp/drain_node.sh $1"
EOF
}

resource "local_file" "wait_node" {
  filename        = "${local.local_scripts_dir}/wait_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

ssh $${SSH_OPTS[@]} "${local.vm_username}@${local.primary_control_plane_ip}" \
  "set -euo pipefail; /tmp/wait_for_empty_volumeattachments.sh $1"
EOF
}

resource "local_file" "delete_node" {
  filename        = "${local.local_scripts_dir}/delete_node.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

ssh $${SSH_OPTS[@]} "${local.vm_username}@${local.primary_control_plane_ip}" \
  "set -euo pipefail; /tmp/delete_node.sh $1"
EOF
}

resource "local_file" "kubeadm_reset" {
  filename        = "${local.local_scripts_dir}/kubeadm_reset.sh"
  file_permission = "0700"
  content         = <<EOF
#!/usr/bin/env bash
set -euo pipefail

node_name=$1

declare -A get_node_ip
${join("\n", [for k, v in local._cluster : "get_node_ip[${k}]=\"${v.ip_address}\""])}

node_ip="$${get_node_ip[$node_name]}"
SSH_OPTS=(-o StrictHostKeyChecking=no -i "${local_sensitive_file.ci.filename}")

ssh $${SSH_OPTS[@]} "${local.vm_username}@$node_ip" \
  "set -euo pipefail; sudo kubeadm reset -f"
EOF
}
