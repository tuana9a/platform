#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Wait until a node has no VolumeAttachments left (e.g. before
# decommissioning/rebooting a node, to ensure CSI volumes have
# fully detached). No jq dependency - uses kubectl's JSONPath.
# ============================================================

export KUBECONFIG="${KUBECONFIG:-/etc/kubernetes/admin.conf}"

NODE_NAME="${1:?NODE_NAME must be set, e.g. worker-1}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-300}"   # total time to wait before giving up
POLL_INTERVAL_SECONDS="${POLL_INTERVAL_SECONDS:-5}"  # how often to re-check

echo "==> Waiting for VolumeAttachments on node '${NODE_NAME}' to be empty (timeout: ${TIMEOUT_SECONDS}s)"

elapsed=0
while true; do
    # List VolumeAttachment names whose .spec.nodeName matches the target node.
    # kubectl's jsonpath range emits one name per line for matching items.
    matching_attachments="$(sudo -E kubectl get volumeattachments.storage.k8s.io \
        -o jsonpath="{range .items[?(@.spec.nodeName==\"${NODE_NAME}\")]}{.metadata.name}{'\n'}{end}")"

    if [[ -z "${matching_attachments}" ]]; then
        echo "==> No VolumeAttachments remain on node '${NODE_NAME}'."
        break
    fi

    count="$(echo "${matching_attachments}" | grep -c . || true)"

    if [[ "${elapsed}" -ge "${TIMEOUT_SECONDS}" ]]; then
        echo "ERROR: timed out after ${TIMEOUT_SECONDS}s waiting for VolumeAttachments on node '${NODE_NAME}' to clear." >&2
        echo "Remaining attachments:" >&2
        echo "${matching_attachments}" >&2
        exit 1
    fi

    echo "    still ${count} VolumeAttachment(s) on '${NODE_NAME}', waiting ${POLL_INTERVAL_SECONDS}s... (elapsed: ${elapsed}s/${TIMEOUT_SECONDS}s)"
    sleep "${POLL_INTERVAL_SECONDS}"
    elapsed=$(( elapsed + POLL_INTERVAL_SECONDS ))
done