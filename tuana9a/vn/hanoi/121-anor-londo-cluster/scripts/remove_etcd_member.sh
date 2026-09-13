#!/usr/bin/env bash
set -euo pipefail

node_name=$1
key_file=$(cat ./tmp/key_file)
ssh_user=$(cat ./tmp/vm_user)
primary_control_plane_ip=$(cat ./tmp/primary_control_plane_ip)

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

scp ${SSH_OPTS[@]} ./scripts/_etcd_member_remove.sh \
  "$ssh_user@$primary_control_plane_ip:/tmp/etcd_member_remove.sh"

ssh ${SSH_OPTS[@]} "$ssh_user@$primary_control_plane_ip" \
  "set -euo pipefail; \
  chmod +x /tmp/etcd_member_remove.sh \
  && /tmp/etcd_member_remove.sh $node_name"
