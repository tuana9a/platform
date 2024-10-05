#!/bin/bash

set -e

source ./envs/r2/.envrc

BUCKET_NAME=$1
FILE_PATTERN=$2

for f in $(find . -type f | grep "$FILE_PATTERN" | sed 's/.\///'); do
  key=platform/$f;
  cmd="aws s3api --endpoint-url "$S3_ENDPOINT_URL" put-object --bucket $BUCKET_NAME --key $key --body $f";
  echo $cmd;
  eval $cmd;
done
