#!/usr/bin/env bash
set -euo pipefail

key_file=$1
ssh_user=$2
node_ip=$3
kubernetes_version=$4

SSH_OPTS=(-o StrictHostKeyChecking=no -i "$key_file")

scp ${SSH_OPTS[@]} ./install-kube.sh $ssh_user@$node_ip:/tmp/install-kube.sh

ssh ${SSH_OPTS[@]} "$ssh_user@$node_ip" \
  "set -euo pipefail; chmod +x /tmp/install-kube.sh && sudo KUBERNETES_VERSION=$kubernetes_version /tmp/install-kube.sh"