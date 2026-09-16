#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "node_ip=\(.node_ip) ssh_user=\(.ssh_user) key_file=\(.key_file) tmp_dir=\(.tmp_dir)"')"

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${key_file}")

JOIN_CMD=$(ssh "${SSH_OPTS[@]}" "${ssh_user}@${node_ip}" "sudo kubeadm token create --print-join-command" 2>/dev/null)

printf '%s' "${JOIN_CMD}" > "$tmp_dir/kube_join_command.txt"

jq -n --arg join_command "$JOIN_CMD" '{"join_command": $join_command}'