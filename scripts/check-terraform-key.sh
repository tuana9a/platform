#!/bin/bash

for f in $(find . -not -path './.git*' -not -path './coder/templates/*' -not -path '*tmp*' -name terraform.tf); do
  dir="$(dirname $f)"
  key=${dir:2}
  if grep --quiet 'prefix' $f; then
    echo "=== $f ==="
    echo "dir = $dir"
    echo "key = $key"
    if ! grep -o "prefix = \"$key\"" $f; then
      echo "status = err"
      exit 1
    fi
    echo "status = ok"
    echo
  fi
done
