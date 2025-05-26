def inventory
def vmids = []

pipeline {
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/etcd-defrag.yml'
            defaultContainer 'shell'
            retries 2
        }
    }
    environment {
        ANSIBLE_HOST_KEY_CHECKING = "false"
    }
    stages {
        stage('Prepare') {
            steps {
                echo "Generate ssh key"
                container('ansible') {
                    sh 'ssh-keygen -t ecdsa -f /workdir/id_rsa && chmod 600 /workdir/id_rsa'
                    script {
                        inventory = readYaml file: "./inventory.yml"
                        inventory["k8s_control_plane"]["hosts"].each { host, vars ->
                            def vmid = vars["vmid"]
                            vmids.add(vmid)
                        }
                    }
                }
                echo "Inject ssh auth key"
                container('kp') {
                    script {
                        for (vmid in vmids) {
                            sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey add --vmid ' + vmid + ' -u u -k "$(cat /workdir/id_rsa.pub)"'
                        }
                    }
                }
            }
        }
        stage('Debug') {
            steps {
                container('ansible') {
                    sh 'cat /workdir/id_rsa'
                    sh 'cat /workdir/id_rsa.pub'
                    script {
                        echo "vmids: $vmids"
                    }
                }
                echo "View ssh keys"
                container('kp') {
                    script {
                        for (vmid in vmids) {
                            sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey view --vmid ' + vmid + ' -u u'
                        }
                    }
                }
            }
        }
        stage('Defrag') {
            steps {
                container('ansible') {
                    // Ref: https://github.com/ahrtr/etcd-defrag/blob/main/doc/etcd-defrag-cronjob.yaml
                    sh 'ansible-playbook -i inventory.yml --key-file /workdir/id_rsa play-622-k8s-control-plane-10-etcd-defrag.yml'
                }
            }
        }
    }
    post {
        always {
            echo 'Cleanup'
            container('kp') {
                script {
                    for (vmid in vmids) {
                        sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey remove --vmid ' + vmid + ' -u u -k "$(cat /workdir/id_rsa.pub)"'
                        sh '/usr/local/bin/kp -c /var/secrets/kp.config.json vm authkey view --vmid ' + vmid + ' -u u'
                    }
                }
            }
        }
    }
}
