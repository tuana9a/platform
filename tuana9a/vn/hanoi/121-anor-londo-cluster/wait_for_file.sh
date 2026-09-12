#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Wait until a file exists, with timeout and progress logging.
# ============================================================

FILE_PATH="${1:?Usage: $0 <file_path> [timeout_seconds] [poll_interval_seconds]}"
TIMEOUT_SECONDS="${2:-300}"
POLL_INTERVAL_SECONDS="${3:-5}"

echo "==> Waiting for file '${FILE_PATH}' to exist (timeout: ${TIMEOUT_SECONDS}s)"

elapsed=0
while true; do
    if [[ -e "${FILE_PATH}" ]]; then
        echo "==> File '${FILE_PATH}' exists. (elapsed: ${elapsed}s/${TIMEOUT_SECONDS}s)"
        break
    fi

    if [[ "${elapsed}" -ge "${TIMEOUT_SECONDS}" ]]; then
        echo "ERROR: timed out after ${TIMEOUT_SECONDS}s waiting for file '${FILE_PATH}' to exist." >&2
        exit 1
    fi

    echo "    still waiting for '${FILE_PATH}'... (elapsed: ${elapsed}s/${TIMEOUT_SECONDS}s)"
    sleep "${POLL_INTERVAL_SECONDS}"
    elapsed=$(( elapsed + POLL_INTERVAL_SECONDS ))
done