#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) KEY_FILE=\(.key_file)"')"

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${KEY_FILE}")

JOIN_CMD=$(ssh "${SSH_OPTS[@]}" "${SSH_USER}@${HOST}" \
  "sudo kubeadm token create --print-join-command" 2>/dev/null)

printf '%s' "${JOIN_CMD}" > "./kube_join_command.tmp.txt"

jq -n --arg join_command "$JOIN_CMD" '{"join_command": $join_command}'