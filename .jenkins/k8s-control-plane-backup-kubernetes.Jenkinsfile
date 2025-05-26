def inventory
def vmids = []

pipeline {
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/backup-kubernetes.yml'
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
                    sh 'cat /var/secrets/backup_env.yml'
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
        stage('Backup') {
            steps {
                container('ansible') {
                    sh 'ansible-playbook -i inventory.yml --key-file /workdir/id_rsa --extra-vars "@/var/secrets/backup_env.yml" play-622-k8s-control-plane-13-backup-kubernetes.yml'
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
