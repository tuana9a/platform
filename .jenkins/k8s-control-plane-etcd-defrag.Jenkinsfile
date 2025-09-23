// Ref: https://github.com/ahrtr/etcd-defrag/blob/main/doc/etcd-defrag-cronjob.yaml

def inventory
def vms = []

pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
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
      volumeMounts:
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
        - name: workdir
          mountPath: "/workdir"
  volumes:
    - name: secrets
      secret:
        secretName: etcd-defrag
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
        stage('prepare') {
            steps {
                echo "set-params"
                container('etcd') {
                    sh 'echo 0 > /workdir/status'
                    sh 'date +%s > /workdir/start.time'
                }
                echo "inventory"
                container('etcd') {
                    script {
                        inventory = readYaml file: "./inventory.yml"
                        inventory["k8s_cluster"]["hosts"].each { host, vars ->
                            if (!vars["is_control_plane"]) {
                                return
                            }
                            def vm = [:]
                            vm["host"] = host
                            vm["vmid"] = vars["vmid"]
                            vm["nodename"] = vars["nodename"]
                            vms.add(vm)
                        }
                    }
                }
                echo "download-k8s-certs"
                container('etcd') {
                    script {
                        sh "cp /var/secrets/ci /workdir/ci && chmod 600 /workdir/ci"
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            sh "ssh -o StrictHostKeyChecking=accept-new -i /workdir/ci root@${host} echo helloworld"
                            sh "scp -i /workdir/ci -r root@${host}:/etc/kubernetes/pki /workdir/pki-${nodename}"
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
        stage('defrag') {
            steps {
                container('etcd') {
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
                                sh "/usr/local/bin/etcdctl defrag --endpoints=${host}:2379 -w=table"
                            }
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
            container('etcd') {
                sh 'date +%s > /workdir/stop.time'
            }
        }
    }
}
