// Ref: https://github.com/ahrtr/etcd-defrag/blob/main/doc/etcd-defrag-cronjob.yaml

def inventory
def vms = []

pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
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
        stage('prepare') {
            steps {
                echo "set-params"
                sh 'echo 0 > /workdir/status'
                sh 'date +%s > /workdir/start.time'

                echo "inventory"
                script {
                    inventory = readYaml file: "./068-k8s-cobi-tuana9a/inventory.yml"
                    inventory["k8s_cluster"]["hosts"].each { host, vars ->
                        if (!vars["roles"].contains("control-plane")) {
                            return
                        }
                        def vm = [:]
                        vm["host"] = host
                        vm["vmid"] = vars["vmid"]
                        vm["nodename"] = vars["nodename"]
                        vm["username"] = vars["ansible_user"]
                        vms.add(vm)
                        echo "Found vm ${host}"
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
                        sh "mkdir -p /workdir/${nodename}/pki"
                        sshagent(credentials: ['id_rsa']) {
                            sh "ssh -o StrictHostKeyChecking=accept-new ${vm['username']}@${host} 'echo helloworld'"
                            sh "ssh ${vm['username']}@${host} 'sudo cat /etc/kubernetes/pki/etcd/ca.crt' > /workdir/${nodename}/pki/ca.crt"
                            sh "ssh ${vm['username']}@${host} 'sudo cat /etc/kubernetes/pki/apiserver-etcd-client.crt' > /workdir/${nodename}/pki/apiserver-etcd-client.crt"
                            sh "ssh ${vm['username']}@${host} 'sudo cat /etc/kubernetes/pki/apiserver-etcd-client.key' > /workdir/${nodename}/pki/apiserver-etcd-client.key"
                        }
                    }
                }
                sh 'find /workdir/'
            }
        }
        stage('defrag') {
            steps {
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        def host = vm["host"]
                        def nodename = vm["nodename"]
                        echo "vmid: ${vmid}"
                        withEnv([
                            "ETCDCTL_CACERT=/workdir/${nodename}/pki/ca.crt",
                            "ETCDCTL_CERT=/workdir/${nodename}/pki/apiserver-etcd-client.crt",
                            "ETCDCTL_KEY=/workdir/${nodename}/pki/apiserver-etcd-client.key",
                        ]) {
                            sh "/devops/tools/bin/etcdctl defrag --endpoints=${host}:2379 -w=table"
                        }
                    }
                }
            }
        }
        stage('finally') { // just a divider
            steps {
                echo "dummy"
                sh 'echo 1 > /workdir/status'
            }
        }
    }
    post {
        always {
            echo 'set-params'
            sh 'date +%s > /workdir/stop.time'
        }
    }
}
