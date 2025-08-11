pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/095-github-runners-terraform-plan-apply.yml'
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    environment {
        http_proxy = "http://proxy.vhost.vn:8080"
        https_proxy = "http://proxy.vhost.vn:8080"
        HTTP_PROXY = "http://proxy.vhost.vn:8080"
        HTTPS_PROXY = "http://proxy.vhost.vn:8080"
        no_proxy = "localhost,127.0.0.1,192.168.0.0/16,172.0.0.0/8,10.244.0.0/8,10.233.0.0/16"
        NO_PROXY = "localhost,127.0.0.1,192.168.0.0/16,172.0.0.0/8,10.244.0.0/8,10.233.0.0/16"
        TERRAFORM_DIR = "095-github-runners"
        GOOGLE_APPLICATION_CREDENTIALS = "$WORKSPACE_TMP/application_default_credentials.json"
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                container('ubuntu') {
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo 0 > /workdir/status'
                }
                echo 'install-tools'
                container('ubuntu') {
                    sh 'apt update'
                    sh 'apt install -y curl wget unzip'
                    sh '''
                    TERRAFORM_VERSION="1.7.1"
                    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                    mv terraform /usr/local/bin/
                    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                    terraform -v
                    '''
                    sh '''
                    apt-get install -y apt-transport-https ca-certificates gnupg curl

                    # Add the Google Cloud public key
                    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

                    # Add the gcloud CLI repository to your sources list
                    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

                    # Update the package index again to include the new repository
                    apt-get update

                    # Install the gcloud CLI
                    apt-get install -y google-cloud-cli

                    # Optional: Initialize the gcloud CLI
                    # This is an interactive step and not suitable for a fully automated script.
                    # To run interactively, uncomment the line below.
                    # gcloud init

                    # Verify the installation
                    gcloud --version
                    '''
                }
            }
        }
        stage('debug') {
            steps {
                container('ubuntu') {
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
                        dir("${env.TERRAFORM_DIR}") {
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
                sh 'date +%s > /workdir/stop.time'
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`github-runners-terraform-plan-apply\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                '''
            }
        }
    }
}