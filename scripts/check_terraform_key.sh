#!/bin/bash

set -e

for f in $(find .  -name terraform.tf -not -path './.git*' -not -path './coder/templates/*' -not -path '*tmp*'); do
  dir="$(dirname $f)"
  key=${dir:2}
  if grep --quiet 'prefix' $f; then
    echo "$f -> $dir -> $key"
    if ! grep -o "prefix = \"$key\"" $f; then
      echo "err"
      exit 1
    fi
    echo "ok"
    echo
  fi
done
