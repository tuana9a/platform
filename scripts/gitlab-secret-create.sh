#!/bin/bash

provider=gitlab.com
repo=$1
echo $repo;

data=$(vault kv get -format=json kv/$provider/$repo | jq -r ".data")
keys=$(echo $data | jq -r ". | to_entries | map(\"\(.key)\") | join(\" \")")

for k in $keys; do
    echo glab variable --repo $repo set --masked $k --value "'$(echo $data | jq -r ".$k")'";
    glab variable --repo $repo set --masked $k --value "'$(echo $data | jq -r ".$k")'";
done
