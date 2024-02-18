#!/bin/bash

BUCKET_NAME=backup
export AWS_PROFILE=r2-backup

function upload() {
  key=$1
  filepath=$2
  if [ -z $key ]; then
    echo key is missing
    echo exiting...
    exit 1
  fi
  if [ -z $filepath ]; then
    filepath=$key;
  fi
  echo upload $key $filepath
  aws s3api --endpoint-url $S3_ENDPOINT_URL put-object --bucket $BUCKET_NAME --key $key --body $filepath
}

upload platform/inventory.secret.yaml *inventory.secret.yaml
tar -czf files.secret.tar.gz files
upload platform/files.secret.tar.gz files.secret.tar.gz