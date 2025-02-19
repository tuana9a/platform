#!/bin/bash

for dir in $(ls -d */); do
  cd $dir
  if [ -f "terraform.tf" ]; then
    key=$(basename "$dir")
    
    # Check if terraform.tf contains 'prefix = "<key>"'
    if grep -q 'prefix = "'$key'"' "terraform.tf"; then
      echo "$dir ok"
    else
      echo "$dir ERROR"
      exit 1
    fi
  else
    echo "$dir empty"
  fi
  cd ..
done
