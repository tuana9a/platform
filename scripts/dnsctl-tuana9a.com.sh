#!/bin/bash

set -euo pipefail

export VAULT_ADDR="https://vault.tuana9a.com"

export CF_EMAIL=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.email')
export CF_ZONE_ID=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.zone_id')
export CF_API_TOKEN=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.api_token')

dnsctl "$@"
