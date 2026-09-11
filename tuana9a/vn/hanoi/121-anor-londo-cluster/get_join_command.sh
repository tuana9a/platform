#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) SSH_KEY_CONTENT=\(.ssh_key_content)"')"

# Write the key content to a temp file - ssh requires a file, not inline content
KEY_FILE=$(mktemp)
trap 'rm -f "${KEY_FILE}"' EXIT

printf '%s\n' "${SSH_KEY_CONTENT}" > "${KEY_FILE}"
chmod 600 "${KEY_FILE}"

JOIN_CMD=$(ssh -o StrictHostKeyChecking=no \
  -i "${KEY_FILE}" \
  "${SSH_USER}@${HOST}" \
  "sudo kubeadm token create --print-join-command" 2>/dev/null)

jq -n --arg join_command "$JOIN_CMD" '{"join_command": $join_command}'