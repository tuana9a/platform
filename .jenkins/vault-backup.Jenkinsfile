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
                sh 'OBJECT_KEY="vault/$(date +"%Y%m%d%H")/vault.snap.tar.gz" && echo $OBJECT_KEY > /workdir/object_key'
            }
        }
        stage('vault') {
            steps {
                withCredentials([
                    file(credentialsId: 'vault-backup.env', variable: 'VAULT_BACKUP_ENV_FILE')
                ]) {
                    echo "renew"
                    sh '''
                    set +x
                    . $VAULT_BACKUP_ENV_FILE
                    /vault/bin/vault token renew > /dev/null
                    '''

                    echo "snapshot"
                    sh '''
                    set +x
                    . $VAULT_BACKUP_ENV_FILE
                    /vault/bin/vault operator raft snapshot save /workdir/vault.snap
                    '''

                    echo "zip"
                    sh 'cd /workdir && tar -czvf vault.snap.tar.gz vault.snap'

                    echo "upload"
                    sh '''
                    set +x
                    . $VAULT_BACKUP_ENV_FILE
                    OBJECT_KEY=$(cat /workdir/object_key)
                    /devops/tools/aws-cli/v2/2.34.32/dist/aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/vault.snap.tar.gz
                    '''

                    echo "upload completed"
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
            sh 'date +%s > /workdir/stop.time'
            withCredentials([
                file(credentialsId: 'vault-backup.env', variable: 'VAULT_BACKUP_ENV_FILE')
            ]) {
                sh '''
                set +x
                . $VAULT_BACKUP_ENV_FILE
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /workdir/object_key)
                case "$(cat /workdir/ruok)" in
                    "yes") status_msg="ok" ;;
                    *) status_msg="fuck" ;;
                esac
                MSG="$status_msg vault-backup $OBJECT_KEY $(($DURATION / 60))m$(($DURATION % 60))s $BUILD_URL"
                curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                    -d chat_id="$TELEGRAM_CHAT_ID" \
                    -d text="$MSG"
                '''
            }
        }
    }
}