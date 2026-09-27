#!/usr/bin/env bash
set -euo pipefail

# Config
NAMESPACE="vault"
STATEFULSET="vault"
REPLICAS=3
KEY_FILES=("secrets/unseal.key.0" "secrets/unseal.key.1" "secrets/unseal.key.2")

for i in $(seq 0 $((REPLICAS - 1))); do
  POD="${STATEFULSET}-${i}"
  echo "== Checking ${POD} =="

  # Skip pod if not found / not ready
  if ! kubectl -n "${NAMESPACE}" get pod "${POD}"; then
    echo "Pod ${POD} not found, skipping."
    continue
  fi

  SEALED=$(kubectl -n "${NAMESPACE}" exec "${POD}" -- vault status -format=json 2>/dev/null | jq -r '.sealed' || echo "unknown")

  if [[ "${SEALED}" == "false" ]]; then
    echo "${POD} already unsealed, skipping."
    continue
  fi

  echo "Unsealing ${POD}..."
  for KEY_FILE in "${KEY_FILES[@]}"; do
    if [[ ! -f "${KEY_FILE}" ]]; then
      echo "Key file ${KEY_FILE} not found!" >&2
      exit 1
    fi
    UNSEAL_KEY=$(<"${KEY_FILE}")
    kubectl -n "${NAMESPACE}" exec "${POD}" -- vault operator unseal "${UNSEAL_KEY}" >/dev/null
  done

  echo "${POD} unseal complete."
done

echo "All pods processed."
