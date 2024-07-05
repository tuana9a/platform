#!/bin/bash

echo "=== $(date) ==="

url="$1"

if [ -z $url ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

authorized_keys_file=~/.ssh/authorized_keys

if [ ! -f "$authorized_keys_file" ]; then
    echo "Error: \"$authorized_keys_file\" do not exist."
    exit 1
fi

line=$(curl $url)

if ! grep -q "$line" "$authorized_keys_file"; then
    echo "Adding \"${line:-10}\""
    echo "$line" >> "$authorized_keys_file"
fi