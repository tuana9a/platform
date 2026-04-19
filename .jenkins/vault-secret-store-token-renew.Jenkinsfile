pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 17 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/ubuntu-pod.yml'
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    environment {
        VAULT_ADDR = "https://vault.tuana9a.com"
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                sh 'date +%s > /workdir/start.time'
                sh 'echo no > /workdir/ruok'
            }
        }
        stage('renew') {
            steps {
                withCredentials([
                    string(credentialsId: 'VAULT_TOKEN', variable: 'VAULT_TOKEN'),
                ]) {
                    sh '''
                    set +x
                    curl -fsS --request POST \
                        --header "X-Vault-Token: $VAULT_TOKEN" \
                        --data '{"increment": "72h"}' \
                        $VAULT_ADDR/v1/auth/token/renew-self
                    '''
                }
                sh 'echo yes > /workdir/ruok'
            }
        }
        stage('finally') {
            steps {
                echo "dummy"
            }
        }
    }
    post {
        always {
            sh 'date +%s > /workdir/stop.time'
            withCredentials([
                string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'TELEGRAM_CHAT_ID'),
                string(credentialsId: 'TELEGRAM_BOT_TOKEN', variable: 'TELEGRAM_BOT_TOKEN'),
            ]) {
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                case "$(cat /workdir/ruok)" in
                    'yes') status_msg="ok" ;;
                    *) status_msg="fuck" ;;
                esac
                MSG="$status_msg vault-secret-store-token-renew $(($DURATION / 60))m$(($DURATION % 60))s $BUILD_URL"
                curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                    -d chat_id="$TELEGRAM_CHAT_ID" \
                    -d text="$MSG"
                '''
            }
        }
    }
}