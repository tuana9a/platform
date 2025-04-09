#!/bin/bash

set -e

echo "===$(date)==="

HOST_NAME="$(hostname)"
CLOUDFLARE_ACCOUNT_ID="{{ KUBERNETES_BACKUP_CLOUDFLARE_ACCOUNT_ID }}"
S3_ENDPOINT="https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com"
BUCKET_NAME="{{ KUBERNETES_BACKUP_BUCKET_NAME }}"
DISCORD_WEBHOOK="{{ KUBERNETES_BACKUP_DISCORD_WEBHOOK }}"

ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt
ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key
ETCDCTL_OPTS="--cacert=$ETCDCTL_CACERT --cert=$ETCDCTL_CERT --key=$ETCDCTL_KEY"

datehour=$(date '+%Y%m%d%H')
hourminutesecond=$(date '+%H%M%S')
unixtimestamp=$(date +%s)
ETCD_SNAPSHOT=/snapshot.db
DUMP_FILE="$datehour-k8s-cobi-$HOST_NAME-backup-kubernetes.tar.gz"
S3_OBJECT_KEY=$DUMP_FILE
WORKDIR=/tmp
SECONDS=0 # for calc duration

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

cd $WORKDIR || exit 1

echo "===Members==="
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl member list $ETCDCTL_OPTS

echo "===Dump $ETCD_SNAPSHOT==="
ETCDCTL_API=3 sudo /usr/local/bin/etcdctl snapshot save $ETCD_SNAPSHOT $ETCDCTL_OPTS

echo "===Status==="
sudo /usr/local/bin/etcdutl --write-out=table snapshot status $ETCD_SNAPSHOT

echo "===Zip==="
echo "$DUMP_FILE"
sudo tar -czvf $DUMP_FILE $ETCD_SNAPSHOT /etc/kubernetes/pki /etc/kubernetes/manifests

echo "===Upload==="
echo "$WORKDIR/$DUMP_FILE -> $S3_OBJECT_KEY"
upload "$S3_OBJECT_KEY" "$DUMP_FILE"

echo "===Cleanup==="
sudo rm -f *snapshot*.db
sudo rm -f *backup-kubernetes*.tar.gz

echo "===Report==="
DURATION=$SECONDS
cat <<EOF | sudo kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-kubernetes-reports-$datehour-$hourminutesecond-$HOST_NAME
  namespace: default
spec:
  ttlSecondsAfterFinished: 10800 # 3 hours
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: backup-kubernetes-reports
        image: alpine/curl
        command:
        - /bin/sh
        - -c
        - |
          push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091";
          POD_NAMESPACE=\$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace);
          echo '# TYPE k8s_backup_datehour gauge
          k8s_backup_datehour{namespace="\$POD_NAMESPACE"} $datehour
          # TYPE k8s_backup_duration gauge
          k8s_backup_duration{namespace="\$POD_NAMESPACE"} $DURATION
          # TYPE k8s_backup_unixtimestamp gauge
          k8s_backup_unixtimestamp{namespace="\$POD_NAMESPACE"} $unixtimestamp' > body.txt
          curl --data-binary @body.txt \$push_gateway_baseurl/metrics/job/k8s_backup_cronjob
EOF

echo "===Notify==="
# MSG=":white_check_mark: \`backup-kubernetes\` \`$HOST_NAME\` \`$(($DURATION / 60))m$(($DURATION % 60))s\`"
# notify "$MSG"
