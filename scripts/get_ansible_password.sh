#!/bin/bash

curl -s --header "X-Vault-Token: $(cat ~/.vault-token)" --request GET https://vault.tuana9a.com/v1/kv/platform/ansible-vault | jq -r '.data.password'
