pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 17 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/test-aws-oidc-pod.yml'
            defaultContainer 'shell'
            retries 2
        }
    }
    environment {
        AWS_ROLE_ARN = 'arn:aws:iam::384588864907:role/test-jenkins-oidc'
        AWS_WEB_IDENTITY_TOKEN_FILE = credentials('aws-oidc-id-token')
    }
    stages {
        stage('Main') {
            steps {
                container('awscli') {
                    sh 'aws sts get-caller-identity'
                    sh 'aws s3api list-buckets'
                }
            }
        }
    }
}