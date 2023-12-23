#!/bin/bash

HOST_NAME="{{ HOST_NAME }}"
AWS_PROFILE_NAME="{{ AWS_PROFILE_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ BUCKET_NAME }}"

DUMP_FILE="nginx-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp

if [ -z $HOST_NAME ]; then echo HOST_NAME not set, default is unknown.; HOST_NAME=unknown; fi
if [ -z $AWS_PROFILE_NAME ]; then echo AWS_PROFILE_NAME not set, default is "default".; AWS_PROFILE_NAME=default; fi
if [ -z $S3_ENDPOINT ]; then echo S3_ENDPOINT not set, exiting.; exit 0; fi
if [ -z $BUCKET_NAME ]; then echo BUCKET_NAME not set, exiting.; exit 0; fi

mkdir -p $WORKDIR
cd $WORKDIR || exit 1

echo Dumping
tar -czvf $WORKDIR/$DUMP_FILE /etc/nginx/nginx.conf /etc/nginx/conf.d /etc/nginx/stream.conf.d

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading $S3_OBJECT_KEY $WORKDIR/$DUMP_FILE
/usr/local/bin/aws --profile $AWS_PROFILE_NAME s3api --endpoint-url $S3_ENDPOINT put-object --key $S3_OBJECT_KEY --bucket $BUCKET_NAME --body $WORKDIR/$DUMP_FILE

if [ $? != 0 ]; then
  echo Something bad happened, exiting
  DURATION=$SECONDS
  MSG="FAILED - host: $HOST_NAME, job: backup-nginx, stage: upload, duration: $(($DURATION / 60))m$(($DURATION % 60))s"
  echo "$MSG"
  exit 1
fi

DURATION=$SECONDS
MSG="SUCCESS - host: $HOST_NAME, job: backup-nginx, duration: $(($DURATION / 60))m$(($DURATION % 60))s"
echo "$MSG"
