#!/usr/bin/env bash
set -euo pipefail

export ETCDCTL_API=3
export ETCDCTL_CACERT="/etc/kubernetes/pki/etcd/ca.crt"
export ETCDCTL_CERT="/etc/kubernetes/pki/apiserver-etcd-client.crt"
export ETCDCTL_KEY="/etc/kubernetes/pki/apiserver-etcd-client.key"

ETCDCTL_BIN="/usr/local/bin/etcdctl"

NODE_NAME="${1:?Usage: $0 <node_name>}"

# ---------- Get etcd member list ----------
echo "==> Fetching etcd member list" >&2
MEMBERS_LIST="$(ETCDCTL_API=3 sudo -E etcdctl member list -w simple)"

# [DEBUG] print etcd members
echo "${MEMBERS_LIST}" >&2

# ---------- Extract member ID for target name ----------
MEMBER_ID="$(echo ${MEMBERS_LIST} | grep $NODE_NAME | cut -f1 -d',' || true)" # | true as grep return non-zero when member id not found

if [[ -z "${MEMBER_ID}" || "${MEMBER_ID}" == "null" ]]; then
    echo "==> No etcd member found with name '${NODE_NAME}'; nothing to remove." >&2
    exit 0
fi

echo "==> Found member ID: ${MEMBER_ID}" >&2

# ---------- Remove etcd member by ID ----------
echo "==> Removing etcd member '${NODE_NAME}' (${MEMBER_ID})" >&2
sudo -E "${ETCDCTL_BIN}" member remove "${MEMBER_ID}"