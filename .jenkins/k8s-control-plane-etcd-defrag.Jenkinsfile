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
                container('ansible') {
                    sh 'cat /var/secrets/id_rsa > ~/id_rsa && chmod 600 ~/id_rsa'
                }
            }
        }
        stage('Debug') {
            steps {
                container('ansible') {
                    sh 'ls -lha ~/id_rsa && cat ~/id_rsa'
                }
            }
        }
        stage('Defrag') {
            steps {
                container('ansible') {
                    // Ref: https://github.com/ahrtr/etcd-defrag/blob/main/doc/etcd-defrag-cronjob.yaml
                    sh 'ansible-playbook -i inventory.ini --key-file ~/id_rsa play-622-k8s-control-plane-10-etcd-defrag.yml'
                }
            }
        }
    }
}
