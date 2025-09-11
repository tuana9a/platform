#!/bin/bash

curl -s --header "X-Vault-Token: $(cat ~/.vault-token)" --request GET https://vault.tuana9a.com/v1/kv/ansible-vault-password | jq -r '.data.password'
