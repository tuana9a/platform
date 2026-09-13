#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "file_content=\(.file_content)"')"

# Write the key content to a temp file - ssh requires a file, not inline content
file_path=$(mktemp)

printf '%s\n' "${file_content}" > "${file_path}"
chmod 600 "${file_path}"

jq -n --arg file_path "$file_path" '{"file_path": $file_path}'
