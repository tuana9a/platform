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
    - name: gcloud
      image: google/cloud-sdk:stable
      command:
        - sleep
      args:
        - infinity
'''
            defaultContainer 'shell'
            retries 2
        }
    }
    stages {
        stage('Main') {
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
