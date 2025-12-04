#!/bin/bash

key=$(basename "$(pwd)")

if [ ! -f terraform.tf ]; then
  echo "skipped (terraform.tf not found)"
  exit 0
fi

echo "terraform.tf found"
sed -i -E 's/prefix = ".+"/prefix = "'$key'"/' terraform.tf
cat terraform.tf | grep prefix
