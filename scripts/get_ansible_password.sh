#!/bin/bash

VAULT_ADDR=https://vault.tuana9a.com vault kv get -field password kv/platform/ansible-vault
