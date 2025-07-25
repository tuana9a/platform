def inventory
def vms = []

pipeline {
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/backup-kubernetes.yml'
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    environment {
        // https://etcd.io/docs/v3.5/op-guide/configuration/#command-line-flags
        // These ETCD_* env variables will be automatically picked up by etcdctl
        ETCDCTL_API = "3"
        http_proxy = "http://proxy.vhost.vn:8080"
        https_proxy = "http://proxy.vhost.vn:8080"
        HTTP_PROXY = "http://proxy.vhost.vn:8080"
        HTTPS_PROXY = "http://proxy.vhost.vn:8080"
        no_proxy = "localhost,127.0.0.1,192.168.0.0/16,172.0.0.0/8,10.244.0.0/8,10.233.0.0/16"
        NO_PROXY = "localhost,127.0.0.1,192.168.0.0/16,172.0.0.0/8,10.244.0.0/8,10.233.0.0/16"
    }
    stages {
        stage('Prepare') {
            steps {
                echo "Set default param"
                container('ubuntu') {
                    sh 'echo 0 > /workdir/status'
                    sh 'date +%s > /workdir/start.time'
                }
                echo "Get vm data"
                container('ubuntu') {
                    script {
                        inventory = readYaml file: "./inventory.yml"
                        inventory["k8s_control_plane"]["hosts"].each { host, vars ->
                            def vm = [:]
                            vm["host"] = host
                            vm["vmid"] = vars["vmid"]
                            vm["nodename"] = vars["nodename"]
                            vms.add(vm)
                        }
                    }
                }
                echo "Generate ssh key"
                container('ubuntu') {
                    sh 'apt update && apt install -y openssh-client'
                    sh 'ssh-keygen -t ecdsa -f /workdir/id_rsa && chmod 600 /workdir/id_rsa'
                }
                echo "Inject ssh key"
                container('kp') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            echo "Inject ssh auth key: ${vmid}"
                            sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey add --vmid ' + vmid + ' -u root -k "$(cat /workdir/id_rsa.pub)"'
                        }
                    }
                }
                echo "Copy k8s pki, manifests"
                container('ubuntu') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "Copy etcd certs and chown"
                            sh "ssh -o StrictHostKeyChecking=accept-new -i /workdir/id_rsa root@${host} echo helloworld"
                            sh "scp -i /workdir/id_rsa -r root@${host}:/etc/kubernetes/pki /workdir/pki-${nodename}"
                            sh "scp -i /workdir/id_rsa -r root@${host}:/etc/kubernetes/manifests /workdir/manifests-${nodename}"
                        }
                    }
                }
                echo "Install etcdctl"
                container('ubuntu') {
                    sh 'apt install -y curl'
                    sh '''
                    ETCD_VER=v3.5.15

                    # choose either URL
                    GOOGLE_URL=https://storage.googleapis.com/etcd
                    GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
                    DOWNLOAD_URL=${GOOGLE_URL}

                    mkdir -p /tmp/etcd-download

                    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
                    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1

                    cp /tmp/etcd-download/etcd* /usr/local/bin/
                    /usr/local/bin/etcdctl version
                    '''
                }
            }
        }
        stage('Debug') {
            steps {
                container('ubuntu') {
                    sh 'ls -lha /workdir/'
                    sh 'ls -lha /var/secrets/'
                    sh 'find /workdir/'
                    sh 'cat /workdir/start.time'
                }
                echo "View ssh keys"
                container('kp') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            echo "vmid: ${vmid}"
                            sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey view --vmid ' + vmid + ' -u root' // username is hardcoded
                        }
                    }
                }
                echo "List etcd members"
                container('ubuntu') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            withEnv([
                                "ETCDCTL_CACERT=/workdir/pki-${nodename}/etcd/ca.crt",
                                "ETCDCTL_CERT=/workdir/pki-${nodename}/apiserver-etcd-client.crt",
                                "ETCDCTL_KEY=/workdir/pki-${nodename}/apiserver-etcd-client.key",
                            ]) {
                                sh "/usr/local/bin/etcdctl member list --endpoints=${host}:2379 -w=table"
                            }
                        }
                    }
                }
            }
        }
        stage('Backup') {
            steps {
                echo 'etcd dump'
                container('ubuntu') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            withEnv([
                                "ETCDCTL_CACERT=/workdir/pki-${nodename}/etcd/ca.crt",
                                "ETCDCTL_CERT=/workdir/pki-${nodename}/apiserver-etcd-client.crt",
                                "ETCDCTL_KEY=/workdir/pki-${nodename}/apiserver-etcd-client.key",
                            ]) {
                                sh "/usr/local/bin/etcdctl snapshot save --endpoints=${host}:2379 /workdir/snapshot-${nodename}.db"
                            }
                            sh "/usr/local/bin/etcdutl snapshot status /workdir/snapshot-${nodename}.db -w=table"
                        }
                    }
                    sh 'ls -lha /workdir/'
                }
                echo 'zip'
                container('ubuntu') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            echo "vmid: ${vmid}"
                            sh "tar -czvf /workdir/k8s-backup-${nodename}.tar.gz /workdir/snapshot-${nodename}.db /workdir/pki-${nodename} /workdir/manifests-${nodename}"
                        }
                    }
                    sh 'ls -lha /workdir/'
                }
                echo 'upload'
                container('awscli') {
                    script {
                        for (vm in vms) {
                            def nodename = vm["nodename"]
                            sh """
                            datehour=\$(date '+%Y%m%d%H')
                            hourminutesecond=\$(date '+%H%M%S')
                            unixtimestamp=\$(date +%s)
                            aws s3api --endpoint-url \$S3_ENDPOINT put-object --bucket \$BUCKET_NAME --key \$datehour-k8s-backup-${nodename}.tar.gz --body /workdir/k8s-backup-${nodename}.tar.gz
                            """
                        }
                    }
                    echo 'upload completed'
                    sh 'echo 1 > /workdir/status'
                }
            }
        }
        stage('Finally') { // just a divider
            steps {
                echo "dummy"
            }
        }
    }
    post {
        always {
            echo 'Cleanup'
            container('kp') {
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        echo "vmid ${vmid}: remove temp key"
                        sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey remove --vmid ' + vmid + ' -u root -k "$(cat /workdir/id_rsa.pub)"'
                        echo "vmid ${vmid}: verify"
                        sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey view --vmid ' + vmid + ' -u root'
                    }
                }
                sh 'date +%s > /workdir/stop.time'
            }
            echo 'Notify'
            container('ubuntu') {
                script {
                    sh '''
                    START_TIME=$(cat "/workdir/start.time")
                    STOP_TIME=$(cat "/workdir/stop.time")
                    DURATION=$((STOP_TIME - START_TIME))
                    case "$(cat /workdir/status)" in
                        1) status_msg=":white_check_mark:" ;;
                        *) status_msg=":x:" ;;
                    esac
                    MSG="$status_msg \\`backup-kubernetes\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                    curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                    '''
                }
            }
        }
    }
}
