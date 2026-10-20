#!/bin/bash

set -euo pipefail

basedir=$(pwd)

for f in $(find * -name terraform.tf -not -path './.git*' -not -path '*tmp*'); do
  dir="$(dirname "$f")"
  echo "$dir"
  cd "$dir"
  terraform fmt
  cd "$basedir"
done
