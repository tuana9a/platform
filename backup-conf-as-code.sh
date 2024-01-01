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
  aws s3api --endpoint-url $S3_ENDPOINT_URL put-object --bucket $BUCKET_NAME --key $key --body $filepath
}

tar -czf files.secret.tar.gz files
tar -czf host_vars.secret.tar.gz host_vars
upload platform/files.secret.tar.gz files.secret.tar.gz
upload platform/host_vars.secret.tar.gz host_vars.secret.tar.gz
upload platform/inventory.secret.yaml inventory.secret.yaml