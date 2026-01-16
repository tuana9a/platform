def inventory
def vms = []

pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 0 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/backup-kubernetes.yml'
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
                        inventory["k8s_cluster_operations"]["hosts"].each { host, vars ->
                            def vm = [:]
                            vm["host"] = host
                            vm["vmid"] = vars["vmid"]
                            vm["nodename"] = vars["nodename"]
                            vms.add(vm)
                        }
                    }
                }
                echo "download-k8s-files"
                container('etcd') {
                    script {
                        sh "cp /var/secrets/ci /workdir/id_rsa && chmod 600 /workdir/id_rsa"
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            sh "mkdir -p /workdir/k8s-backup-${nodename}"
                            sh "ssh -o StrictHostKeyChecking=accept-new -i /workdir/id_rsa root@${host} echo helloworld"
                            sh "scp -i /workdir/id_rsa -r root@${host}:/etc/kubernetes/pki /workdir/k8s-backup-${nodename}/pki"
                            sh "scp -i /workdir/id_rsa -r root@${host}:/etc/kubernetes/manifests /workdir/k8s-backup-${nodename}/manifests"
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
                            sh '''
                            set +x
                            export CLOUDFLARE_ACCOUNT_ID="$(cat /var/secrets/CLOUDFLARE_ACCOUNT_ID)"
                            export S3_ENDPOINT="$(cat /var/secrets/S3_ENDPOINT)"
                            export BUCKET_NAME="$(cat /var/secrets/BUCKET_NAME)"
                            export AWS_ACCESS_KEY_ID="$(cat /var/secrets/AWS_ACCESS_KEY_ID)"
                            export AWS_SECRET_ACCESS_KEY="$(cat /var/secrets/AWS_SECRET_ACCESS_KEY)"
                            export AWS_DEFAULT_REGION="auto"
                            set -x
                            aws s3api --endpoint-url $S3_ENDPOINT put-object --bucket $BUCKET_NAME --key $(cat /workdir/datehour)-k8s-backup-''' + nodename + '''.tar.gz --body /workdir/k8s-backup-''' + nodename + '''.tar.gz
                            '''
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

                    for (vm in vms) {
                        def nodename = vm["nodename"]
                        sh '''
                        case "$(cat /workdir/status)" in
                            1) status_msg="ok" ;;
                            *) status_msg="fuck" ;;
                        esac
                        MSG="$status_msg backup-kubernetes $(cat /workdir/datehour)-k8s-backup-''' + nodename + '''.tar.gz $(cat /workdir/duration_pretty.txt) $BUILD_URL"
                        set +x
                        curl -sS -X POST "https://api.telegram.org/bot$(cat /var/secrets/TELEGRAM_BOT_TOKEN)/sendMessage" \
                            -d chat_id="$(cat /var/secrets/TELEGRAM_CHAT_ID)" \
                            -d text="$MSG"
                        '''
                    }

                    sh '''
                    push_gateway_baseurl="http://prometheus-pushgateway.prometheus.svc.cluster.local:9091";
                    POD_NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace);
                    cat << EOF | curl -sS --noproxy '*' --data-binary @- $push_gateway_baseurl/metrics/job/k8s_backup_cronjob
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
