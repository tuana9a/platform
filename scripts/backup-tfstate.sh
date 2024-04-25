#!/bin/bash

dir=$1
if [ -z $dir ]; then
  dir=infra;
fi

echo BUCKET_NAME=$BUCKET_NAME
if [[ -z "$BUCKET_NAME" ]]; then
  echo missing BUCKET_NAME
  exit 1
fi

echo S3_ENDPOINT_URL=$S3_ENDPOINT_URL
if [[ -z "$S3_ENDPOINT_URL" ]]; then
  echo missing S3_ENDPOINT_URL
  exit 1
fi

filepaths=$(find $dir -name 'terraform.tfstate');

for f in $filepaths; do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done

filepaths=$(find $dir -name '*.secret.*');

for f in $filepaths; do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done
