#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "node_ip=\(.node_ip) ssh_user=\(.ssh_user) key_file=\(.key_file)"')"

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${key_file}")

scp ${SSH_OPTS[@]} ./scripts/_install-etcdctl.sh $ssh_user@$node_ip:/tmp/install-etcdctl.sh

result="$(ssh ${SSH_OPTS[@]} "$ssh_user@$node_ip" \
  "set -euo pipefail; \
  chmod +x /tmp/install-etcdctl.sh \
  && /tmp/install-etcdctl.sh"
)"

jq -n --arg result "$result" '{"result": $result}'