#!/bin/bash

set -e

source ./envs/r2/.envrc

BUCKET_NAME=secrets
FOLDER=secrets.tmp

for f in $(find $FOLDER -type f); do
  key=$(echo platform/$f | sed 's/.tmp//');
  cmd="aws s3api --endpoint-url "$S3_ENDPOINT_URL" put-object --bucket $BUCKET_NAME --key $key --body $f";
  echo $cmd;
  eval $cmd;
done
