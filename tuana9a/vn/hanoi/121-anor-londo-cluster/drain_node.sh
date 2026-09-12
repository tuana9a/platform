#!/usr/bin/env bash
set -euo pipefail

node_name=$1
key_file=$(cat ./tmp/key_file)
ssh_user=$(cat ./tmp/vm_user)
primary_control_plane_ip=$(cat ./tmp/primary_control_plane_ip)

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

ssh ${SSH_OPTS[@]} "$ssh_user@$primary_control_plane_ip" \
  "set -euo pipefail; \
  sudo KUBECONFIG="/etc/kubernetes/admin.conf" \
  kubectl drain $node_name --ignore-daemonsets --delete-emptydir-data --disable-eviction --force"
