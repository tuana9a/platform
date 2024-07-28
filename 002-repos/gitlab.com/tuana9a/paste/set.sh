#!/bin/bash

var_dir=.s9cr9t
repo=tuana9a/paste

for x in $(ls $var_dir); do
    glab variable --repo $repo set --masked $x --value "$(ansible-vault view $var_dir/$x)"
done