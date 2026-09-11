#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "HOST=\(.host) SSH_USER=\(.ssh_user) SSH_KEY_CONTENT=\(.ssh_key_content)"')"

# Write the key content to a temp file - ssh requires a file, not inline content
KEY_FILE=$(mktemp)
trap 'rm -f "${KEY_FILE}"' EXIT

printf '%s\n' "${SSH_KEY_CONTENT}" > "${KEY_FILE}"
chmod 600 "${KEY_FILE}"

# args: list of remote cert paths to fetch, e.g.
#   ./get_kube_certs.sh /etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/ca.key ...
if [[ $# -eq 0 ]]; then
    echo "ERROR: no cert paths provided as arguments" >&2
    exit 1
fi

SSH_OPTS=(-o StrictHostKeyChecking=no -i "${KEY_FILE}")

# Fetch a remote file's content, base64-encoded, or empty string if missing.
fetch_cert_b64() {
    local remote_path="$1"
    ssh "${SSH_OPTS[@]}" "${SSH_USER}@${HOST}" \
        "sudo test -f '${remote_path}' && sudo cat '${remote_path}' | base64 -w0 || true" 2>/dev/null
}

# Build the JSON object incrementally: one --arg pair + one jq filter fragment per cert path
json_args=()
json_filter="{"

first=true
for cert_path in "$@"; do
    content_b64="$(fetch_cert_b64 "${cert_path}")"
    var_name="v$(echo -n "${cert_path}" | md5sum | cut -c1-8)"  # unique-ish placeholder name

    json_args+=(--arg "${var_name}" "${content_b64}")

    if [[ "${first}" == true ]]; then
        first=false
    else
        json_filter+=","
    fi
    json_filter+="$(jq -n --arg k "${cert_path}" '$k'):\$${var_name}"
done

json_filter+="}"

jq -n "${json_args[@]}" "${json_filter}"