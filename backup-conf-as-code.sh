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
tar -czf host_vars.secret.tar.gz host_vars
upload platform/files.secret.tar.gz files.secret.tar.gz
upload platform/host_vars.secret.tar.gz host_vars.secret.tar.gz
upload platform/inventory.secret.yaml inventory.secret.yaml