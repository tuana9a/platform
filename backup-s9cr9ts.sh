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

for f in $(find secrets -type f); do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done

for f in $(find [0-9]* -type f -name '*secret*'); do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done
