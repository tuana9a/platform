pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: odin
  containers:
    - name: ubuntu
      image: tuana9a/toolbox:terraform-1.7.1_gcloud-latest
      command:
        - sleep
      args:
        - infinity
      env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      envFrom:
        - secretRef:
            name: 020-proxmox-cloud-img-terraform-plan-apply
      volumeMounts:
        - name: workdir
          mountPath: /workdir
        - name: tfvars
          mountPath: "/var/secrets"
          readOnly: true

  restartPolicy: Never
  volumes:
    - name: workdir
      emptyDir: {}
    - name: tfvars
      secret:
        secretName: 020-proxmox-cloud-img-terraform-plan-apply
'''
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "$WORKSPACE_TMP/application_default_credentials.json"
        WORKING_DIR = "020-proxmox-cloud-img"
        PIPELINE_NAME = "020-proxmox-cloud-img"
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                container('ubuntu') {
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo 0 > /workdir/status'
                    sh 'ls -lha /workdir/'
                    sh 'cat /workdir/start.time'
                }
            }
        }
        stage('terraform') {
            steps {
                container('ubuntu') {
                    withCredentials([file(variable: 'ID_TOKEN_FILE', credentialsId: 'gcp-oidc-id-token')]) {
                        writeFile file: "$WORKSPACE_TMP/application_default_credentials.json", text: """{
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
                        sh 'ls -lha $GOOGLE_APPLICATION_CREDENTIALS'
                        dir("${env.WORKING_DIR}") {
                            sh 'terraform init'
                            sh 'cp /var/secrets/tfvars hidden.tmp.auto.tfvars'
                            sh 'terraform plan -out tfplan.out'
                            sh 'terraform apply -auto-approve tfplan.out'
                        }
                    }
                    sh 'echo 1 > /workdir/status'
                }
            }
        }
        stage('noti') {
            steps {
                echo "dummy"
            }
        }
    }
    post {
        always {
            container('ubuntu') {
                script {
                    sh 'date +%s > /workdir/stop.time'
                    sh '''
                    START_TIME=$(cat "/workdir/start.time")
                    STOP_TIME=$(cat "/workdir/stop.time")
                    DURATION=$((STOP_TIME - START_TIME))
                    case "$(cat /workdir/status)" in
                        1) status_msg=":white_check_mark:" ;;
                        *) status_msg=":x:" ;;
                    esac
                    MSG="$status_msg \\`$PIPELINE_NAME\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                    curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                    '''
                }
            }
        }
    }
}