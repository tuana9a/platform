#!/bin/bash

set -e

secrets_file=$1

plain_text=$(sops -d "$secrets_file")

jq -n --arg plain_text "$plain_text" '{"plain_text":$plain_text}'
