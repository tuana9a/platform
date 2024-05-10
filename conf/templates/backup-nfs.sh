#!/bin/bash

echo "=== $(date) ==="

HOST_NAME="{{ HOST_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ NFS_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ NFS_BACKUP_BUCKET_NAME }}"

export AWS_ACCESS_KEY_ID="{{ NFS_BACKUP_AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ NFS_BACKUP_AWS_SECRET_ACCESS_KEY }}"
export AWS_DEFAULT_REGION="{{ NFS_BACKUP_AWS_DEFAULT_REGION | default('auto') }}"

TELEGRAM_BOT_TOKEN="{{ NFS_BACKUP_TELEGRAM_BOT_TOKEN | default('') }}"
TELEGRAM_CHAT_ID="{{ NFS_BACKUP_TELEGRAM_CHAT_ID | default('') }}"

BACKUP_DIR=$1
DUMP_PREFIX=$2

if [ -z $DUMP_PREFIX ]; then echo DUMP_PREFIX is not set, default is "nfs".; DUMP_PREFIX=nfs; fi

DUMP_FILE="$DUMP_PREFIX-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp
SECONDS=0 # for calc duration

if [ -z "$HOST_NAME" ]; then echo HOST_NAME is not set, default is "unknown".; HOST_NAME=unknown; fi
if [ -z "$BACKUP_DIR" ]; then echo BACKUP_DIR is not set, exiting.; exit 1; fi
if [ -z "$S3_ENDPOINT" ]; then echo S3_ENDPOINT is not set, exiting.; exit 1; fi
if [ -z "$BUCKET_NAME" ]; then echo BUCKET_NAME is not set, exiting.; exit 1; fi

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
tar \
  --exclude .git \
  --exclude .venv \
  --exclude .m2 \
  --exclude .vscode-server \
  --exclude node_modules \
  --exclude .cache \
  --exclude .terraform \
  --exclude .tfenv \
  --exclude .angular \
  --exclude 'Python-*' \
  --exclude 'amazon-corretto-*' \
  --exclude '.nvm' \
  --exclude '.npm' \
  --exclude '*.lock' \
  -cvzf $DUMP_FILE $BACKUP_DIR

if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-nfs $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading "$S3_OBJECT_KEY" "$WORKDIR/$DUMP_FILE"
upload "$S3_OBJECT_KEY" "$DUMP_FILE"

if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-nfs $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

DURATION=$SECONDS
MSG="SUCCESS $HOST_NAME backup-nfs $BACKUP_DIR $(($DURATION / 60))m$(($DURATION % 60))s"
notify "$MSG"

rm $DUMP_PREFIX-dump-*.tar.gz
