#!/bin/bash

set -euo pipefail

export VAULT_ADDR="https://vault.tuana9a.com"

CF_EMAIL=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.email')
export CF_EMAIL

CF_ZONE_ID=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.zone_id')
export CF_ZONE_ID

CF_API_TOKEN=$(vault kv get -format=json kv/cloudflare/zones/tuana9a.com | jq -r '.data.api_token')
export CF_API_TOKEN

dnsctl "$@"
