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
                # ubuntu runs as root by default,
                # it is recommended or even mandatory in some environments
                # (such as pod security admission "restricted") to run as a non-root user.
                runAsUser: 1000
              - name: gcloud
                image: google/cloud-sdk:stable
                command:
                - sleep
                args:
                - 999999
            '''
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
        AWS_WEB_IDENTITY_TOKEN_FILE = credentials('gcp-oidc-id-token')
    }
    stages {
        stage('Debug') {
            steps {
              sh 'hostname'
              sh 'pwd'
            }
        }
        stage('List objects') {
            steps {
                container('gcloud') {
                    withCredentials([file(variable: 'ID_TOKEN_FILE', credentialsId: 'gcp-oidc-id-token')]) {
                        writeFile file: "$WORKSPACE_TMP/creds.json", text: """{
                          "type": "external_account",
                          "audience": "//iam.googleapis.com/projects/474326114337/locations/global/workloadIdentityPools/jenkins/providers/jenkins-tuana9a-com",
                          "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
                          "token_url": "https://sts.googleapis.com/v1/token",
                          "service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/terraform-state-editor@tuana9a.iam.gserviceaccount.com:generateAccessToken",
                          "credential_source": {
                            "file": "$ID_TOKEN_FILE",
                            "format": {
                              "type": "text"
                            }
                          }
                        }"""
                        sh 'gcloud auth login --brief --cred-file=$WORKSPACE_TMP/creds.json'
                        sh 'gcloud auth list'
                        sh 'gcloud storage ls gs://terraform-tuana9a/'
                    }
                }
            }
        }
    }
}
