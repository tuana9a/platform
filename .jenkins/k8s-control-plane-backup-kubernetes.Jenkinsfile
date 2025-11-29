def inventory
def vms = []

pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 0 * * *') }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: etcd
      image: tuana9a/toolbox:etcd-3.5.15
      command:
        - sleep
      args:
        - infinity
      env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      envFrom:
        - secretRef:
            name: backup-kubernetes-env
      volumeMounts:
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
        - name: workdir
          mountPath: "/workdir"
    - name: awscli
      image: amazon/aws-cli:2.18.0
      command:
        - sleep
      args:
        - infinity
      envFrom:
        - secretRef:
            name: backup-kubernetes-env
      volumeMounts:
        - name: workdir
          mountPath: /workdir
  volumes:
    - name: secrets
      secret:
        secretName: backup-kubernetes
    - name: secrets-env
      secret:
        secretName: backup-kubernetes-env
    - name: workdir
      emptyDir: {}
'''
            defaultContainer 'etcd'
            retries 2
        }
    }
    environment {
        // https://etcd.io/docs/v3.5/op-guide/configuration/#command-line-flags
        // These ETCD_* env variables will be automatically picked up by etcdctl
        ETCDCTL_API = "3"
    }
    stages {
        stage('Prepare') {
            steps {
                echo "set-params"
                container('etcd') {
                    sh 'echo 0 > /workdir/status'
                    sh 'date +%s > /workdir/start.time'
                    sh 'date "+%Y%m%d%H" > /workdir/datehour'
                    sh 'date "+%H%M%S" > /workdir/hourminutesecond'
                    sh 'date +%s > /workdir/unixtimestamp'
                }
                echo "inventory"
                container('etcd') {
                    script {
                        inventory = readYaml file: "./inventory.yml"
                        inventory["k8s_cluster_primary_master"]["hosts"].each { host, vars ->
                            def vm = [:]
                            vm["host"] = host
                            vm["vmid"] = vars["vmid"]
                            vm["nodename"] = vars["nodename"]
                            vms.add(vm)
                        }
                    }
                }
                echo "download-k8s-certs-and-manifests"
                container('etcd') {
                    script {
                        sh "cp /var/secrets/ci /workdir/ci && chmod 600 /workdir/ci"
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            sh "mkdir -p /workdir/k8s-backup-${nodename}"
                            sh "ssh -o StrictHostKeyChecking=accept-new -i /workdir/ci root@${host} echo helloworld"
                            sh "scp -i /workdir/ci -r root@${host}:/etc/kubernetes/pki /workdir/k8s-backup-${nodename}/pki"
                            sh "scp -i /workdir/ci -r root@${host}:/etc/kubernetes/manifests /workdir/k8s-backup-${nodename}/manifests"
                        }
                    }
                }
                echo "list-files"
                container('etcd') {
                    sh 'ls -lha /var/secrets/'
                    sh 'ls -lha /workdir/'
                    sh 'find /workdir/'
                }
                echo "list-etcd-members"
                container('etcd') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            withEnv([
                                "ETCDCTL_CACERT=/workdir/k8s-backup-${nodename}/pki/etcd/ca.crt",
                                "ETCDCTL_CERT=/workdir/k8s-backup-${nodename}/pki/apiserver-etcd-client.crt",
                                "ETCDCTL_KEY=/workdir/k8s-backup-${nodename}/pki/apiserver-etcd-client.key",
                            ]) {
                                sh "/usr/local/bin/etcdctl member list --endpoints=${host}:2379 -w=table"
                            }
                        }
                    }
                }
            }
        }
        stage('backup') {
            steps {
                echo 'snapshot'
                container('etcd') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            withEnv([
                                "ETCDCTL_CACERT=/workdir/k8s-backup-${nodename}/pki/etcd/ca.crt",
                                "ETCDCTL_CERT=/workdir/k8s-backup-${nodename}/pki/apiserver-etcd-client.crt",
                                "ETCDCTL_KEY=/workdir/k8s-backup-${nodename}/pki/apiserver-etcd-client.key",
                            ]) {
                                sh "/usr/local/bin/etcdctl snapshot save --endpoints=${host}:2379 /workdir/k8s-backup-${nodename}/snapshot.db"
                            }
                            sh "/usr/local/bin/etcdutl snapshot status /workdir/k8s-backup-${nodename}/snapshot.db -w=table"
                        }
                    }
                    sh 'ls -lha /workdir/'
                }
                echo 'zip'
                container('etcd') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            sh "tar -czvf /workdir/k8s-backup-${nodename}.tar.gz /workdir/k8s-backup-${nodename}/"
                        }
                    }
                    sh 'ls -lha /workdir/'
                }
                echo 'upload'
                container('awscli') {
                    script {
                        for (vm in vms) {
                            def nodename = vm["nodename"]
                            sh "aws s3api --endpoint-url \$S3_ENDPOINT put-object --bucket \$BUCKET_NAME --key \$(cat /workdir/datehour)-k8s-backup-${nodename}.tar.gz --body /workdir/k8s-backup-${nodename}.tar.gz"
                        }
                    }
                    echo 'upload completed'
                    sh 'echo 1 > /workdir/status'
                }
            }
        }
        stage('finally') { // just a divider
            steps {
                echo "dummy"
            }
        }
    }
    post {
        always {
            echo 'set-params'
            container('etcd') {
                sh 'date +%s > /workdir/stop.time'
            }
            echo 'notify'
            container('etcd') {
                script {
                    sh '''
                    START_TIME=$(cat "/workdir/start.time")
                    STOP_TIME=$(cat "/workdir/stop.time")
                    DURATION=$((STOP_TIME - START_TIME))
                    DURATION_PRETTY="$(($DURATION / 60))m$(($DURATION % 60))s"
                    echo $DURATION > /workdir/duration.time
                    echo $DURATION_PRETTY > /workdir/duration_pretty.txt
                    '''
                    sh '''
                    case "$(cat /workdir/status)" in
                        1) status_msg=":white_check_mark:" ;;
                        *) status_msg=":x:" ;;
                    esac
                    MSG="$status_msg \\`backup-kubernetes\\` \\`$(cat /workdir/duration_pretty.txt)\\` $BUILD_URL"
                    curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                    '''
                    sh '''
                    push_gateway_baseurl="http://prometheus-pushgateway.prometheus.svc.cluster.local:9091";
                    POD_NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace);
                    cat << EOF | curl --noproxy '*' --data-binary @- $push_gateway_baseurl/metrics/job/k8s_backup_cronjob
# TYPE k8s_backup_datehour gauge
k8s_backup_datehour{namespace="$POD_NAMESPACE"} $(cat /workdir/datehour)
# TYPE k8s_backup_duration gauge
k8s_backup_duration{namespace="$POD_NAMESPACE"} $(cat /workdir/duration.time)
# TYPE k8s_backup_unixtimestamp gauge
k8s_backup_unixtimestamp{namespace="$POD_NAMESPACE"} $(cat /workdir/unixtimestamp)
EOF
                    '''
                }
            }
        }
    }
}
