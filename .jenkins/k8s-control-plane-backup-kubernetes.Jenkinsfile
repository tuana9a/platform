pipeline {
    agent {
        kubernetes {
            yamlFile '.jenkins/backup-kubernetes.yml'
            defaultContainer 'shell'
            retries 2
        }
    }
    environment {
        ANSIBLE_HOST_KEY_CHECKING = "false"
    }
    stages {
        stage('Main') {
            steps {
                container('ansible') {
                    sh 'echo "$id_rsa" > ~/id_rsa && chmod 600 ~/id_rsa'
                    sh 'echo $ansible_password > ~/.ansible-password && chmod 600 ~/.ansible-password'
                    sh 'cat ~/id_rsa'
                    sh 'cat ~/.ansible-password'
                    sh 'ansible-playbook -i inventory.ini --key-file ~/id_rsa --vault-password-file ~/.ansible-password play-622-k8s-control-plane-13-backup-kubernetes.yml'
                }
            }
        }
    }
}
