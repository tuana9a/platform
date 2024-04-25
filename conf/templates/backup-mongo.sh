#!/bin/bash

echo "=== $(date) ==="

HOST_NAME="{{ HOST_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ MONGO_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
BUCKET_NAME="{{ MONGO_BACKUP_BUCKET_NAME }}"
MONGO_CONNECTION_STRING="{{ MONGO_BACKUP_MONGO_CONNECTION_STRING }}"

export AWS_ACCESS_KEY_ID="{{ MONGO_BACKUP_AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ MONGO_BACKUP_AWS_SECRET_ACCESS_KEY }}"
export AWS_DEFAULT_REGION="{{ MONGO_BACKUP_AWS_DEFAULT_REGION | default('auto') }}"

TELEGRAM_BOT_TOKEN="{{ MONGO_BACKUP_TELEGRAM_BOT_TOKEN }}"
TELEGRAM_CHAT_ID="{{ MONGO_BACKUP_TELEGRAM_CHAT_ID }}"

S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
SECONDS=0 # for calc duration
DUMP_FILE="mongo-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp

if [ -z "$HOST_NAME" ]; then echo HOST_NAME is not set, default is "unknown".; HOST_NAME=unknown; fi
if [ -z "$MONGO_CONNECTION_STRING" ]; then echo MONGO_CONNECTION_STRING is not set, exiting.; exit 0; fi
if [ -z "$S3_ENDPOINT" ]; then echo S3_ENDPOINT is not set, exiting.; exit 0; fi
if [ -z "$BUCKET_NAME" ]; then echo BUCKET_NAME is not set, exiting.; exit 0; fi
if [ -z "$TELEGRAM_BOT_TOKEN" ]; then echo TELEGRAM_BOT_TOKEN is not set, exiting.; exit 0; fi
if [ -z "$TELEGRAM_CHAT_ID" ]; then echo TELEGRAM_CHAT_ID is not set, exiting.; exit 0; fi

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
/usr/local/bin/mongodump "$MONGO_CONNECTION_STRING"
if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-mongo $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

echo Zipping
tar -czvf "$DUMP_FILE" dump
if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-mongo $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading "$S3_OBJECT_KEY" "$WORKDIR/$DUMP_FILE"
upload $S3_OBJECT_KEY $DUMP_FILE

if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-mongo $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

DURATION=$SECONDS
MSG="SUCCESS $HOST_NAME backup-mongo $(($DURATION / 60))m$(($DURATION % 60))s"
notify "$MSG"
