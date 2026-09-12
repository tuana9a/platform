#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="${OUTPUT_DIR:-tmp}"
mkdir -p "${OUTPUT_DIR}"

# Read the query object from stdin (sent by terraform's external data source)
QUERY_JSON="$(cat)"

# Write one file per key: filename = key, content = value
while IFS= read -r key; do
    value="$(echo "${QUERY_JSON}" | jq -r --arg k "${key}" '.[$k]')"
    printf '%s' "${value}" > "${OUTPUT_DIR}/${key}"
    echo "==> wrote ${OUTPUT_DIR}/${key}" >&2
done < <(echo "${QUERY_JSON}" | jq -r 'keys[]')

# external requires a flat JSON object (string -> string) as output.
# Echo the query back as confirmation of what was written.
echo "${QUERY_JSON}" | jq '.'