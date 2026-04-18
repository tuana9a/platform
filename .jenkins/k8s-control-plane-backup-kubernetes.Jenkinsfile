def inventory
def vms = []

pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 17 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/ubuntu-pod.yml'
            defaultContainer 'ubuntu'
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
                sh 'echo 0 > /workdir/status'
                sh 'date +%s > /workdir/start.time'
                sh 'date "+%Y%m%d%H" > /workdir/datehour'
                sh 'date "+%H%M%S" > /workdir/hourminutesecond'
                sh 'date +%s > /workdir/unixtimestamp'
                echo "inventory"
                script {
                    inventory = readYaml file: "./068-k8s-cobi-tuana9a/inventory.yml"
                    inventory["k8s_cluster"]["hosts"].each { host, vars ->
                        if (vars["roles"].contains("control-plane")) {
                            def vm = [:]
                            vm["host"] = host
                            vm["vmid"] = vars["vmid"]
                            vm["nodename"] = vars["nodename"]
                            vm["username"] = vars["ansible_user"]
                            vms.add(vm)
                            echo "Found vm ${host}"
                        }
                    }
                    if (!vms || vms.isEmpty()) {
                        error("No control-plane VMs found in inventory")
                    }
                }
                echo "download-certs"
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        def host = vm["host"]
                        def nodename = vm["nodename"]
                        sh "mkdir -p /workdir/${nodename}"
                        sh "mkdir -p /workdir/${nodename}/pki/etcd"
                        sh "mkdir -p /workdir/${nodename}/manifests"
                        sshagent(credentials: ['id_rsa']) {
                            sh "ssh -o StrictHostKeyChecking=accept-new ${vm['username']}@${host} 'echo helloworld'"
                            def stdout = sh(script: "ssh ${vm['username']}@${host} 'cd /etc/kubernetes && sudo find * -type f'", returnStdout: true).trim()
                            def fileList = stdout.split(/\r?\n/)
                            fileList.each { f ->
                                sh "ssh ${vm['username']}@${host} 'sudo cat /etc/kubernetes/${f}' > /workdir/${nodename}/${f}"
                            }
                        }
                    }
                }
                sh 'find /workdir/'
            }
        }
        stage('backup') {
            steps {
                echo 'snapshot'
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        def host = vm["host"]
                        def nodename = vm["nodename"]
                        echo "vmid: ${vmid}"
                        withEnv([
                            "ETCDCTL_CACERT=/workdir/${nodename}/pki/etcd/ca.crt",
                            "ETCDCTL_CERT=/workdir/${nodename}/pki/apiserver-etcd-client.crt",
                            "ETCDCTL_KEY=/workdir/${nodename}/pki/apiserver-etcd-client.key",
                        ]) {
                            sh "/devops/tools/bin/etcdctl snapshot save --endpoints=${host}:2379 /workdir/${nodename}/snapshot.db"
                        }
                        sh "/devops/tools/bin/etcdutl snapshot status /workdir/${nodename}/snapshot.db -w=table"
                    }
                }
                echo 'zip'
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        def host = vm["host"]
                        def nodename = vm["nodename"]
                        echo "vmid: ${vmid}"
                        sh "tar -czvf /workdir/${nodename}.tar.gz /workdir/${nodename}/"
                    }
                }
                echo 'upload'
                script {
                    for (vm in vms) {
                        def nodename = vm["nodename"]
                        withCredentials([
                            file(credentialsId: 'k8s-backup.env', variable: 'K8S_BACKUP_ENV_FILE')
                        ]) {
                            sh '''
                            set +x
                            . $K8S_BACKUP_ENV_FILE
                            /devops/tools/aws-cli/v2/2.34.32/dist/aws s3api --endpoint-url $S3_ENDPOINT put-object --bucket $BUCKET_NAME --key k8s-backup/$(cat /workdir/datehour)/''' + nodename + '''.tar.gz --body /workdir/''' + nodename + '''.tar.gz
                            '''
                        }
                    }
                }
                echo 'upload completed'
                sh 'echo 1 > /workdir/status'
            }
        }
        // just a divider
        stage('finally') {
            steps {
                echo "dummy"
            }
        }
    }
    post {
        always {
            echo 'set-params'
            sh 'date +%s > /workdir/stop.time'
            echo 'notify'
            script {
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                DURATION_PRETTY="$(($DURATION / 60))m$(($DURATION % 60))s"
                echo $DURATION > /workdir/duration.time
                echo $DURATION_PRETTY > /workdir/duration_pretty.txt
                '''

                def nodenames = vms.collect { it["nodename"] } .join(",")

                withCredentials([
                    file(credentialsId: 'k8s-backup.env', variable: 'K8S_BACKUP_ENV_FILE')
                ]) {
                    sh '''
                    set +x
                    . $K8S_BACKUP_ENV_FILE
                    case "$(cat /workdir/status)" in
                        1) status_msg="ok" ;;
                        *) status_msg="fuck" ;;
                    esac
                    MSG="$status_msg backup-kubernetes $(cat /workdir/datehour)-k8s-backup-{''' + nodenames + '''}.tar.gz $(cat /workdir/duration_pretty.txt) $BUILD_URL"
                    curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                        -d parse_mode="markdown" \
                        -d chat_id="$TELEGRAM_CHAT_ID" \
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
