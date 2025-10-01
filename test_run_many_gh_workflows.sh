#!/bin/bash

ref="$(git branch --show-current)"

while getopts "r:" opt; do
  case $opt in
    r) ref="$OPTARG"; ;;
    ?) exit 1 ;;
  esac
done

echo ref=$ref

for x in $(find '.github/workflows' -type f); do
  grep -q "workflow_dispatch" $x
  has_dispatch=$?
  grep -q "inputs" $x
  has_inputs=$?
  # echo $x $has_dispatch $has_inputs
  if [[ $has_dispatch -eq 0 ]] && [[ $has_inputs -ne 0 ]]; then
    echo gh workflow run --ref $ref $(basename $x)
    gh workflow run --ref $ref $(basename $x) &
  fi
done
