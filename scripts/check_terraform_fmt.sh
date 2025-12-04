#!/bin/bash

set -euo pipefail

basedir=$(pwd)

for f in $(find * -maxdepth 1 -name terraform.tf -not -path './.git*' -not -path '*tmp*'); do
  dir="$(dirname "$f")"
  echo "$dir"
  cd "$dir"
  terraform fmt -check
  cd "$basedir"
done
