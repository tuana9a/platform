#!/usr/bin/env bash
set -euo pipefail

key_file=$1
ssh_user=$2
node_ip=$3

TIMEOUT=300
INTERVAL=5

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

echo "==> Waiting for SSH on $ssh_user@$node_ip (timeout: ${TIMEOUT}s)..."

start_time=$(date +%s)

while true; do
  if ssh "${SSH_OPTS[@]}" "$ssh_user@$node_ip" true; then
    echo "SSH is up on $node_ip"
    break
  fi

  now=$(date +%s)
  elapsed=$(( now - start_time ))
  if (( elapsed >= TIMEOUT )); then
    echo "Timed out after ${TIMEOUT}s waiting for SSH on $node_ip" >&2
    exit 1
  fi

  sleep "$INTERVAL"
done

echo "==> Waiting for cloud-init on $ssh_user@$node_ip"
ssh "${SSH_OPTS[@]}" "$ssh_user@$node_ip" "cloud-init status --wait"
echo "cloud-init on node $node_ip is done."
