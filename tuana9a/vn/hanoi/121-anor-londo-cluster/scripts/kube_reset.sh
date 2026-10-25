#!/usr/bin/env bash
set -euo pipefail

node_name=$1
key_file=$(cat ./tmp/key_file)
ssh_user=$(cat ./tmp/vm_user)
node_ip=$(cat ./tmp/${node_name}_node_ip)

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

ssh ${SSH_OPTS[@]} "$ssh_user@$node_ip" \
  "set -euo pipefail; \
  sudo kubeadm reset -f"
