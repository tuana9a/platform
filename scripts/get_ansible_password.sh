#!/bin/bash

curl -sSf --header "X-Vault-Token: $(cat ~/.vault-token)" --request GET https://vault.tuana9a.com/v1/kv/ansible/vault | jq -r '.data.password'
