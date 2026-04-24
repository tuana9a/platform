#!/bin/bash

set -euo pipefail

if [ ! -f terraform.tf ]; then
	echo "ERROR: terraform.tf not found"
	exit 1
fi

echo "terraform.tf found"

start_dir="$(pwd)"
current_dir="$start_dir"

while true; do
	if [[ -f "$current_dir/.root_terraform_key" ]]; then
		# Found the root marker
		key="${start_dir#"$current_dir"/}"

		# Handle case where start_dir == current_dir
		if [[ "$start_dir" == "$current_dir" ]]; then
			exit 2
		fi

		break
	fi

	# If reached filesystem root, stop
	if [[ "$current_dir" == "/" ]]; then
		echo "Error: .root_terraform_key not found in any parent directory" >&2
		exit 3
	fi

	current_dir="$(dirname "$current_dir")"
done

echo "key: $key"

sed -i -E "s|prefix = .+|prefix = \"$key\"|" terraform.tf

cat terraform.tf | grep prefix
