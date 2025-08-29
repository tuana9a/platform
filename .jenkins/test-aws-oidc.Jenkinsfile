pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yaml '''
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
        - infinity            
'''
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