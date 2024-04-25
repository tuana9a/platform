#!/bin/bash

echo "=== $(date) ==="

HOST_NAME="{{ HOST_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ NGINX_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
BUCKET_NAME="{{ NGINX_BACKUP_BUCKET_NAME }}"
TELEGRAM_BOT_TOKEN="{{ NGINX_BACKUP_TELEGRAM_BOT_TOKEN | default('') }}"
TELEGRAM_CHAT_ID="{{ NGINX_BACKUP_TELEGRAM_CHAT_ID | default('') }}"

export AWS_ACCESS_KEY_ID="{{ NGINX_BACKUP_AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ NGINX_BACKUP_AWS_SECRET_ACCESS_KEY }}"
export AWS_DEFAULT_REGION="{{ NGINX_BACKUP_AWS_DEFAULT_REGION | default('auto') }}"

S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
DUMP_FILE="nginx-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp

if [ -z $HOST_NAME ]; then echo HOST_NAME not set, default is unknown.; HOST_NAME=unknown; fi
if [ -z $S3_ENDPOINT ]; then echo S3_ENDPOINT not set, exiting.; exit 0; fi
if [ -z $BUCKET_NAME ]; then echo BUCKET_NAME not set, exiting.; exit 0; fi

if [[ -n $TELEGRAM_BOT_TOKEN || -n $TELEGRAM_CHAT_ID ]]; then
notify() {
  msg=$1
  echo Send msg: "$msg"
  curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":$TELEGRAM_CHAT_ID,\"disable_notification\":true,\"text\":\"$msg\"}"
  echo
}
else
notify() {
  msg=$1
  echo WARN: TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID is not set
  echo $msg
}
fi

upload() {
  KEY=$1
  FILEPATH=$2
  /usr/local/bin/aws s3api --endpoint-url $S3_ENDPOINT put-object --bucket $BUCKET_NAME --key $KEY --body $FILEPATH
}

mkdir -p $WORKDIR
cd $WORKDIR || exit 1

echo Dumping
tar -czvf $WORKDIR/$DUMP_FILE /etc/nginx/nginx.conf /etc/nginx/conf.d /etc/nginx/stream.conf.d

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading $S3_OBJECT_KEY $WORKDIR/$DUMP_FILE
upload $S3_OBJECT_KEY $WORKDIR/$DUMP_FILE

if [ $? != 0 ]; then
  echo Something bad happened, exiting
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-nginx $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

DURATION=$SECONDS
MSG="SUCCESS $HOST_NAME backup-nginx $(($DURATION / 60))m$(($DURATION % 60))s"
notify "$MSG"
