#!/bin/bash

set -e

echo "=== $(date) ==="

HOST_NAME="$(hostname)"
CLOUDFLARE_ACCOUNT_ID="{{ KUBERNETES_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ KUBERNETES_BACKUP_BUCKET_NAME }}"

datehour=$(date '+%Y%m%d%H');
unixtimestamp=$(date +%s);
ETCD_SNAPSHOT=/tmp/snapshot.db
DUMP_FILE="$datehour-k8s-cobi-$HOST_NAME-backup-kubernetes.tar.gz"
S3_OBJECT_KEY=$DUMP_FILE
WORKDIR=/tmp
SECONDS=0 # for calc duration

# DISCORD_WEBHOOK="{{ KUBERNETES_BACKUP_DISCORD_WEBHOOK }}"

export AWS_ACCESS_KEY_ID="{{ KUBERNETES_BACKUP_AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ KUBERNETES_BACKUP_AWS_SECRET_ACCESS_KEY }}"
export AWS_DEFAULT_REGION="{{ KUBERNETES_BACKUP_AWS_DEFAULT_REGION | default('auto') }}"

if [ -z "$HOST_NAME" ]; then echo HOST_NAME is not set, default is "unknown".; HOST_NAME=unknown; fi
if [ -z "$S3_ENDPOINT" ]; then echo S3_ENDPOINT is not set, exiting.; exit 1; fi
if [ -z "$BUCKET_NAME" ]; then echo BUCKET_NAME is not set, exiting.; exit 1; fi

notify() {
  msg=$1
  echo Send msg: "$msg"
  curl -X POST "$DISCORD_WEBHOOK" -H "Content-Type: application/json" -d "{\"content\":\"$msg\"}"
  echo
}

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

echo Dumping
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl member list $ETCDCTL_OPTS
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl snapshot save $ETCD_SNAPSHOT $ETCDCTL_OPTS
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl --write-out=table snapshot status $ETCD_SNAPSHOT $ETCDCTL_OPTS

echo Zipping $DUMP_FILE
sudo tar -czvf $DUMP_FILE $ETCD_SNAPSHOT /etc/kubernetes/pki /etc/kubernetes/manifests

echo Uploading "$S3_OBJECT_KEY" "$WORKDIR/$DUMP_FILE"
upload "$S3_OBJECT_KEY" "$DUMP_FILE"

# cleanup
sudo rm -f snapshot.db
sudo rm -f *backup-kubernetes*.tar.gz

DURATION=$SECONDS
# MSG=":white_check_mark: \`backup-kubernetes\` \`$HOST_NAME\` \`$(($DURATION / 60))m$(($DURATION % 60))s\`"
# notify "$MSG"

kubectl --kubeconfig /etc/kubernetes/admin.conf -n default run backup-kubernetes-reports-$datehour-$RANDOM \
--image=amazon/aws-cli:2.18.0 \
--restart=Never \
--namespace=default \
--command -- /bin/sh -c '
push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091";
POD_NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace);

cat <<EOF | curl --data-binary @- $push_gateway_baseurl/metrics/job/k8s_backup_cronjob
# TYPE k8s_backup_datehour gauge
k8s_backup_datehour{namespace="$POD_NAMESPACE"} '$datehour'
# TYPE k8s_backup_duration gauge
k8s_backup_duration{namespace="$POD_NAMESPACE"} '$DURATION'
# TYPE k8s_backup_unixtimestamp gauge
k8s_backup_unixtimestamp{namespace="$POD_NAMESPACE"} '$unixtimestamp'
EOF
'
