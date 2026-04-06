#!/bin/bash

set -e

secrets_file=./github_secrets.enc.yml

plain_text=$(sops -d $secrets_file)

jq -n --arg plain_text "$plain_text" '{"plain_text":$plain_text}'
