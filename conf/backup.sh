#!/bin/bash

BUCKET_NAME=backup

function upload() {
  key=$1
  filepath=$2
  if [ -z $key ]; then
    echo key is missing, exiting.
    exit 1
  fi
  if [ -z $filepath ]; then
    filepath=$key;
  fi
  r2 $BUCKET_NAME put $key $filepath
}

tar -czf files.secret.tar.gz files
upload platform/conf/files.secret.tar.gz files.secret.tar.gz
upload platform/conf/inventory.secret.yaml inventory.secret.yaml