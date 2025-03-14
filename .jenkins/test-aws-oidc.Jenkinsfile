pipeline {
    agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            //     image 'ubuntu'
            //     command 'sleep'
            //     args 'infinity'
            // }
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: shell
    image: ubuntu
    command:
    - sleep
    args:
    - infinity
    securityContext:
      # ubuntu runs as root by default, it is recommended or even mandatory in some environments (such as pod security admission "restricted") to run as a non-root user.
      runAsUser: 1000
  - name: awscli
    image: amazon/aws-cli
    command:
    - sleep
    args:
    - 999999
"""
            // Can also wrap individual steps:
            // container('shell') {
            //     sh 'hostname'
            // }
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