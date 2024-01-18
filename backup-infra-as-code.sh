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

upload platform/locals.secret.tf locals.secret.tf
upload platform/terraform.tfstate terraform.tfstate