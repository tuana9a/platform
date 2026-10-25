#!/usr/bin/env bash
set -euo pipefail

node_name=$1
key_file=$(cat ./tmp/key_file)
ssh_user=$(cat ./tmp/vm_user)
primary_control_plane_ip=$(cat ./tmp/primary_control_plane_ip)

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

scp ${SSH_OPTS[@]} ./scripts/_wait_node_volumeattachments_empty.sh \
  "$ssh_user@$primary_control_plane_ip:/tmp/wait_node_volumeattachments_empty.sh"

ssh ${SSH_OPTS[@]} "$ssh_user@$primary_control_plane_ip" \
  "set -euo pipefail; \
  chmod +x /tmp/wait_node_volumeattachments_empty.sh \
  && /tmp/wait_node_volumeattachments_empty.sh $node_name"
