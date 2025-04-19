pipeline {
    agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            yamlFile '.jenkins/test-aws-oidc.yml'
            defaultContainer 'shell'
            retries 2
        }
    }
    environment {
        AWS_ROLE_ARN = 'arn:aws:iam::384588864907:role/test-jenkins-oidc'
        AWS_WEB_IDENTITY_TOKEN_FILE = credentials('aws-oidc-id-token')
    }
    stages {
        stage('Debug') {
            steps {
                sh 'hostname'
                sh 'pwd'
            }
        }
        stage('List buckets') {
            steps {
                container('awscli') {
                    sh 'aws sts get-caller-identity'
                    sh 'aws s3api list-buckets'
                }
            }
        }
    }
}