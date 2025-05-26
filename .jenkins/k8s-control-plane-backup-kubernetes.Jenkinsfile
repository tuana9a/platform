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
                container('ansible') {
                    sh 'cat /var/secrets/id_rsa > ~/id_rsa && chmod 600 ~/id_rsa'
                }
            }
        }
        stage('Debug') {
            steps {
                container('ansible') {
                    sh 'ls -lha ~/id_rsa && cat ~/id_rsa'
                    sh 'cat /var/secrets/backup_env.yml'
                }
            }
        }
        stage('Backup') {
            steps {
                container('ansible') {
                    sh 'ansible-playbook -i inventory.ini --key-file ~/id_rsa --extra-vars "@/var/secrets/backup_env.yml" play-622-k8s-control-plane-13-backup-kubernetes.yml'
                }
            }
        }
    }
}
