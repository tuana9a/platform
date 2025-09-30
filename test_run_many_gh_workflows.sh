#!/bin/bash

for x in $(find '.github/workflows' -type f); do
    if [[ $(grep -q "workflow_dispatch" $x) -eq 0 ]]; then
        gh workflow run $(basename $x) &
    fi
done
