#!/bin/bash

set -euo pipefail

delimiter=">"

for f in $(find * -maxdepth 1 -name terraform.tf -not -path './.git*' -not -path '*tmp*'); do
  dir="$(dirname "$f")"
  key=$dir
  if grep --quiet 'prefix' "$f"; then
    echo -n "$f $delimiter $dir $delimiter "
    if ! grep -o "prefix = \"$key\"" "$f"; then
      echo "ERROR"
      exit 1
    fi
  fi
done
