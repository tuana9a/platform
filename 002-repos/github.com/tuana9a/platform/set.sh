#!/bin/bash

var_dir=.s9cr9t
repo=tuana9a/platform

for x in $(ls $var_dir); do
    gh secret --repo $repo set $x --body "$(ansible-vault view $var_dir/$x)"
done