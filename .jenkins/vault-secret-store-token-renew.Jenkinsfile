pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 0 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/vault-secret-store-token-renew.yml'
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
                container('ubuntu') {
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo no > /workdir/ruok'
                }
            }
        }
        stage('renew') {
            steps {
                container('vault') {
                    sh '''
                    set +x
                    VAULT_TOKEN=$(cat /var/secrets/token) vault token renew > /dev/null
                    '''
                    sh 'echo yes > /workdir/ruok'
                }
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
            container('ubuntu') {
                sh 'date +%s > /workdir/stop.time'
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