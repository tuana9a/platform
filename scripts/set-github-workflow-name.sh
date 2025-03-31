#!/bin/bash

file=$1

if [ -z "$file" ]; then
  echo "Usage: set-github-workflow-name.sh"
  exit 1
fi

name=$(basename $file | cut -d . -f 1 | sed -E 's|[0-9]+-||g' | sed -E 's|-| |g')

echo "$file -> $name"

sed -i -E "s/^name: .+/name: \"$name\"/" "$file"
