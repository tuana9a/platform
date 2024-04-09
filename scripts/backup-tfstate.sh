#!/bin/bash

dir=$1
if [ -z $dir ]; then
  dir=infra;
fi
echo BUCKET_NAME=$BUCKET_NAME
echo S3_ENDPOINT_URL=$S3_ENDPOINT_URL

filepaths=$(find $dir -name 'terraform.tfstate');

for f in $filepaths; do
  key=platform/$f;
  echo PUT: $key $f
  /usr/local/bin/r2.sh put-object $key $f;
done