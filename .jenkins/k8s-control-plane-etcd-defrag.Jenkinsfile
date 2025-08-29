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
    - name: ubuntu
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
    - name: kp
      image: tuana9a/kp:main-9c68a63
      command:
        - /bin/sh
      args:
        - -c
        - "sleep infinity"
      volumeMounts:
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
        - name: workdir
          mountPath: "/workdir"
  volumes:
    - name: secrets
      secret:
        secretName: backup-kubernetes
    - name: workdir
      emptyDir: {}
'''
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
        stage('prepare') {
            steps {
                echo "set-params"
                container('ubuntu') {
                    sh 'echo 0 > /workdir/status'
                    sh 'date +%s > /workdir/start.time'
                }
                echo "get-vm-data"
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
                echo "generate-ssh-key"
                container('ubuntu') {
                    sh 'ssh-keygen -t ecdsa -f /workdir/id_rsa && chmod 600 /workdir/id_rsa'
                }
                echo "jnject-ssh-key"
                container('kp') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            echo "Inject ssh auth key: ${vmid}"
                            sh "/usr/local/bin/kp -c /var/secrets/kp.config.json authkey add --vmid ${vmid} -u root -k \"\$(cat /workdir/id_rsa.pub)\""
                        }
                    }
                }
                echo "download-k8s-certs"
                container('ubuntu') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            def host = vm["host"]
                            def nodename = vm["nodename"]
                            sh "ssh -o StrictHostKeyChecking=accept-new -i /workdir/id_rsa root@${host} echo helloworld"
                            sh "scp -i /workdir/id_rsa -r root@${host}:/etc/kubernetes/pki /workdir/pki-${nodename}"
                        }
                    }
                }
            }
        }
        stage('debug') {
            steps {
                container('ubuntu') {
                    sh 'ls -lha /var/secrets/'
                    sh 'ls -lha /workdir/'
                    sh 'find /workdir/'
                }
                echo "view-ssh-keys"
                container('kp') {
                    script {
                        for (vm in vms) {
                            def vmid = vm["vmid"]
                            echo "vmid: ${vmid}"
                            sh "/usr/local/bin/kp -c /var/secrets/kp.config.json authkey view --vmid ${vmid} -u root" // username is hardcoded
                        }
                    }
                }
                echo "list-etcd-members"
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
        stage('defrag') {
            steps {
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
            container('ubuntu') {
                sh 'date +%s > /workdir/stop.time'
            }
            echo 'cleanup'
            container('kp') {
                script {
                    for (vm in vms) {
                        def vmid = vm["vmid"]
                        echo "vmid ${vmid}: remove temp key"
                        sh "/usr/local/bin/kp -c /var/secrets/kp.config.json authkey remove --vmid ${vmid} -u root -k \"\$(cat /workdir/id_rsa.pub)\""
                        echo "vmid ${vmid}: verify"
                        sh "/usr/local/bin/kp -c /var/secrets/kp.config.json authkey view --vmid ${vmid} -u root"
                    }
                }
            }
        }
    }
}
