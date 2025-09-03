#!/bin/bash

set -euo pipefail

for f in $(find .  -name terraform.tf -not -path './.git*' -not -path './coder/templates/*' -not -path '*tmp*'); do
  dir="$(dirname $f)"
  echo "$dir"
  cd $dir
  terraform fmt -check
  cd ..
done
