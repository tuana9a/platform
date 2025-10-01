pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '100')) }
    // triggers {
    //     githubPush()
    // }
    agent {
        kubernetes {
            yamlFile '.jenkins/TerraformPlanApplyNotify.yaml'
        }
    }
    parameters { 
        string(name: 'WORKINGDIR', description: 'Working folder')
        string(name: 'GCP_PROJECT_ID', defaultValue: 'tuana9a', description: 'GCP Project ID')
        string(name: 'GCP_PROJECT_NUM', defaultValue: '474326114337', description: 'GCP Project Number')
        string(name: 'GCP_SERVICE_ACCOUNT', defaultValue: 'terraform-state-editor@tuana9a.iam.gserviceaccount.com', description: 'GCP Service Account Email')
        string(name: 'GCP_WORKLOAD_IDENTITY_POOL', defaultValue: 'jenkins', description: 'GCP Workload Identity Pool Name')
        string(name: 'GCP_WORKLOAD_IDENTITY_POOL_PROVIDER', defaultValue: 'jenkins-tuana9a-com', description: 'GCP Workload Identity Pool Provider Name')
    }
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "$WORKSPACE_TMP/application_default_credentials.json"
        WORKINGDIR = "${params.WORKINGDIR}"
        GCP_PROJECT_ID = "${params.GCP_PROJECT_ID}"
        GCP_PROJECT_NUM = "${params.GCP_PROJECT_NUM}"
        GCP_SERVICE_ACCOUNT = "${params.GCP_SERVICE_ACCOUNT}"
        GCP_WORKLOAD_IDENTITY_POOL = "${params.GCP_WORKLOAD_IDENTITY_POOL}"
        GCP_WORKLOAD_IDENTITY_POOL_PROVIDER = "${params.GCP_WORKLOAD_IDENTITY_POOL_PROVIDER}"
    }
    stages {
        stage('prepare') {
            steps {
                script {
                    currentBuild.displayName = "#${env.BUILD_NUMBER} - ${params.WORKINGDIR}"
                }
                container('terraform') {
                    echo 'set-params'
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo "no" > /workdir/ruok'
                    echo 'add-missing-files'
                    dir(params.WORKINGDIR) {
                        sh 'set +x; curl -sSf -X GET https://vault.tuana9a.com/v1/kv/github.com/tuana9a/platform/' + params.WORKINGDIR + '/terraform -H "X-Vault-Token: $VAULT_TOKEN" -o vault_data.json'
                        sh '''
                        for x in $(jq -r '.data._files_' vault_data.json); do echo "=== $x ==="; jq -r '.data."'$x'"' vault_data.json > $x; done
                        '''
                    }
                }
            }
        }
        stage('terraform') {
            steps {
                container('terraform') {
                    withCredentials([file(variable: 'ID_TOKEN_FILE', credentialsId: 'gcp-oidc-id-token')]) {
                        writeFile file: "$WORKSPACE_TMP/application_default_credentials.json", text: """{
                            "type": "external_account",
                            "audience": "//iam.googleapis.com/projects/${params.GCP_PROJECT_NUM}/locations/global/workloadIdentityPools/${params.GCP_WORKLOAD_IDENTITY_POOL}/providers/${params.GCP_WORKLOAD_IDENTITY_POOL_PROVIDER}",
                            "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
                            "token_url": "https://sts.googleapis.com/v1/token",
                            "service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${params.GCP_SERVICE_ACCOUNT}:generateAccessToken",
                            "credential_source": {
                                "file": "$ID_TOKEN_FILE",
                                "format": {
                                    "type": "text"
                                }
                            }
                        }"""
                        dir(params.WORKINGDIR) {
                            sh 'terraform init -input=false'
                            sh 'terraform plan -input=false -out tfplan.out'
                            sh 'terraform apply -input=false -auto-approve tfplan.out'
                        }
                    }
                    sh 'echo "yes" > /workdir/ruok'
                }
            }
        }
        stage('finally') {
            steps {
                echo "notify"
            }
        }
    }
    post {
        always {
            container('terraform') {
                script {
                    sh 'date +%s > /workdir/stop.time'
                    sh '''
                    START_TIME=$(cat "/workdir/start.time")
                    STOP_TIME=$(cat "/workdir/stop.time")
                    DURATION=$((STOP_TIME - START_TIME))
                    case "$(cat /workdir/ruok)" in
                        "yes") status=":white_check_mark:" ;;
                        *) status=":x:" ;;
                    esac
                    MSG="$status \\`$WORKINGDIR\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                    curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                    '''
                }
            }
        }
    }
}