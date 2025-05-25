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
                    sh 'echo $id_rsa'
                    sh 'mkdir ~/.ssh && chmod 700 ~/.ssh'
                    sh 'echo $id_rsa > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa'
                    sh 'printenv'
                    sh 'ansible-playbook -i inventory.ini --key-file "/var/secrets/id_rsa" --vault-password-file "/var/secrets/ansible_password" play-622-k8s-control-plane-13-backup-kubernetes.yml'
                }
            }
        }
    }
}
