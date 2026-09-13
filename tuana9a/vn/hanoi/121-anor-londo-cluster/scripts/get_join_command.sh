#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) KEY_FILE=\(.key_file) tmp_dir=\(.tmp_dir)"')"

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${KEY_FILE}")

JOIN_CMD=$(ssh "${SSH_OPTS[@]}" "${SSH_USER}@${HOST}" \
  "sudo kubeadm token create --print-join-command" 2>/dev/null)

printf '%s' "${JOIN_CMD}" > "$tmp_dir/kube_join_command.txt"

jq -n --arg join_command "$JOIN_CMD" '{"join_command": $join_command}'