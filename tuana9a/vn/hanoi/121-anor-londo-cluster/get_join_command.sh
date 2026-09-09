#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) KEY_FILE=\(.ssh_key_file)"')"

JOIN_CMD=$(ssh -o StrictHostKeyChecking=no \
  -i "${KEY_FILE}" \
  "${SSH_USER}@${HOST}" \
  "sudo kubeadm token create --print-join-command" 2>/dev/null)

jq -n --arg join_command "$JOIN_CMD" '{"join_command": $join_command}'