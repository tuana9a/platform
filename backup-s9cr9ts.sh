#!/bin/bash

source ./envs/r2/s9cr9ts/.envrc

echo S3_ENDPOINT_URL=$S3_ENDPOINT_URL
if [[ -z "$S3_ENDPOINT_URL" ]]; then
  echo missing S3_ENDPOINT_URL
  exit 1
fi

echo BUCKET_NAME=$BUCKET_NAME
if [[ -z "$BUCKET_NAME" ]]; then
  echo missing BUCKET_NAME
  exit 1
fi

filepaths=$(find app/ conf/ infra/ -type f -name '*secret*');

for f in $filepaths; do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done

dirs=$(find app/ conf/ infra/ -type d -name '*secret*');

for d in $dirs; do
  for f in $d/*; do
    key=platform/$f;
    echo PUT: $key $f
    /usr/local/bin/r2.sh put-object $key $f;
  done
done
