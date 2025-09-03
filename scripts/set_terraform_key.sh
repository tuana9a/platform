#!/bin/bash

key=$(basename $PWD)

if [ ! -f terraform.tf ]; then
  echo "terraform.tf not found"
  echo "exit 0"
  exit 0
fi

echo "terraform.tf found"
sed -i -E 's/prefix = ".+"/prefix = "'$key'"/' terraform.tf
cat terraform.tf | grep prefix