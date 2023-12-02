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

upload platform/locals.secret.tf locals.secret.tf