#!/bin/bash

provider=github.com
repo=$1
echo $repo;

data=$(vault kv get -format=json kv/$provider/$repo | jq -r ".data")
keys=$(echo $data | jq -r ". | to_entries | map(\"\(.key)\") | join(\" \")")

for k in $keys; do
    echo gh secret --repo $repo set $k --body "'$(echo $data | jq -r ".$k")'";
    gh secret --repo $repo set $k --body "'$(echo $data | jq -r ".$k")'";
done
