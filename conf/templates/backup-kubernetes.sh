#!/bin/bash

HOST_NAME="{{ HOST_NAME }}"
AWS_PROFILE_NAME="{{ AWS_PROFILE_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ BUCKET_NAME }}"

TELEGRAM_BOT_TOKEN="{{ TELEGRAM_BOT_TOKEN | default('') }}"
TELEGRAM_CHAT_ID="{{ TELEGRAM_CHAT_ID | default('') }}"

ETCD_SNAPSHOT=/tmp/snapshot.db
DUMP_FILE="kubernetes-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp
SECONDS=0 # for calc duration

if [ -z "$HOST_NAME" ]; then echo HOST_NAME is not set, default is "unknown".; HOST_NAME=unknown; fi
if [ -z "$AWS_PROFILE_NAME" ]; then echo AWS_PROFILE_NAME is not set, default is "default".; AWS_PROFILE_NAME=default; fi
if [ -z "$S3_ENDPOINT" ]; then echo S3_ENDPOINT is not set, exiting.; exit 0; fi
if [ -z "$BUCKET_NAME" ]; then echo BUCKET_NAME is not set, exiting.; exit 0; fi

notify() {
  echo Send msg: "$1"
  if [[ -n $TELEGRAM_BOT_TOKEN ]]; then
    curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
      -H "Content-Type: application/json" \
      -d "{\"chat_id\":$TELEGRAM_CHAT_ID,\"disable_notification\":true,\"text\":\"$1\"}"
    echo
    exit 0
  fi
  echo TELEGRAM_BOT_TOKEN is not set, sending message ignored
}

mkdir -p $WORKDIR
cd $WORKDIR || exit 1

ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt
ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key
ETCDCTL_OPTS="--cacert=$ETCDCTL_CACERT --cert=$ETCDCTL_CERT --key=$ETCDCTL_KEY"

ETCDCTL_API=3 sudo etcdctl member list $ETCDCTL_OPTS
ETCDCTL_API=3 sudo etcdctl snapshot save $ETCD_SNAPSHOT $ETCDCTL_OPTS
ETCDCTL_API=3 sudo etcdctl --write-out=table snapshot status $ETCD_SNAPSHOT $ETCDCTL_OPTS

echo Dumping
sudo tar -czvf $DUMP_FILE /tmp/snapshot.db /etc/kubernetes/pki /etc/kubernetes/manifests

if [ ! $? ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED - host: $HOST_NAME, job: backup-kubernetes, stage: zip, duration: $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading "$S3_OBJECT_KEY" "$WORKDIR/$DUMP_FILE"
/usr/local/bin/aws --profile $AWS_PROFILE_NAME s3api --endpoint-url "$S3_ENDPOINT" put-object --key "$S3_OBJECT_KEY" --bucket "$BUCKET_NAME" --body "$DUMP_FILE"

if [ ! $? ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED - host: $HOST_NAME, job: backup-mongo, stage: upload, duration: $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi