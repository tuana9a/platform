pipeline {
    agent {
        kubernetes {
            yamlFile '.jenkins/ansible.yml'
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
                    // Ref: https://github.com/ahrtr/etcd-defrag/blob/main/doc/etcd-defrag-cronjob.yaml
                    sh 'ansible-playbook -i inventory.ini --key-file "/var/secrets/id_rsa" --vault-password-file "/var/secrets/ansible_password" play-622-k8s-control-plane-10-etcd-defrag.yml'
                }
            }
        }
    }
}
