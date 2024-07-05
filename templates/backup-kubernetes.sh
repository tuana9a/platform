#!/bin/bash

echo "=== $(date) ==="

HOST_NAME="{{ HOST_NAME }}"
CLOUDFLARE_ACCOUNT_ID="{{ KUBERNETES_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ KUBERNETES_BACKUP_BUCKET_NAME }}"

export AWS_ACCESS_KEY_ID="{{ KUBERNETES_BACKUP_AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ KUBERNETES_BACKUP_AWS_SECRET_ACCESS_KEY }}"
export AWS_DEFAULT_REGION="{{ KUBERNETES_BACKUP_AWS_DEFAULT_REGION | default('auto') }}"

TELEGRAM_BOT_TOKEN="{{ KUBERNETES_BACKUP_TELEGRAM_BOT_TOKEN | default('') }}"
TELEGRAM_CHAT_ID="{{ KUBERNETES_BACKUP_TELEGRAM_CHAT_ID | default('') }}"

ETCD_SNAPSHOT=/tmp/snapshot.db
DUMP_FILE="kubernetes-dump-$(date +'%Y.%m.%d').tar.gz"
WORKDIR=/tmp
SECONDS=0 # for calc duration

if [ -z "$HOST_NAME" ]; then echo HOST_NAME is not set, default is "unknown".; HOST_NAME=unknown; fi
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

ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt
ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key
ETCDCTL_OPTS="--cacert=$ETCDCTL_CACERT --cert=$ETCDCTL_CERT --key=$ETCDCTL_KEY"

ETCDCTL_API=3 sudo /usr/local/bin/etcdctl member list $ETCDCTL_OPTS
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl snapshot save $ETCD_SNAPSHOT $ETCDCTL_OPTS
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl --write-out=table snapshot status $ETCD_SNAPSHOT $ETCDCTL_OPTS

echo Dumping
sudo tar -czvf $DUMP_FILE /tmp/snapshot.db /etc/kubernetes/pki /etc/kubernetes/manifests

if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-kubernetes $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

S3_OBJECT_KEY=$HOST_NAME/$DUMP_FILE
echo Uploading "$S3_OBJECT_KEY" "$WORKDIR/$DUMP_FILE"
upload "$S3_OBJECT_KEY" "$DUMP_FILE"

if [ $? != 0 ]; then
  echo Something bad happened, exiting.
  DURATION=$SECONDS
  MSG="FAILED $HOST_NAME backup-kubernetes $(($DURATION / 60))m$(($DURATION % 60))s"
  notify "$MSG"
  exit 1
fi

DURATION=$SECONDS
MSG="SUCCESS $HOST_NAME backup-kubernetes $(($DURATION / 60))m$(($DURATION % 60))s"
notify "$MSG"
