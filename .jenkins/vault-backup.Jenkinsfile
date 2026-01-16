pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 0 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/vault-backup.yml'
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
                    sh 'OBJECT_KEY=$(date +"%Y%m%d%H")-vault.snapshot.tar.gz && echo $OBJECT_KEY > /workdir/object_key'
                }
            }
        }
        stage('renew') {
            steps {
                container('vault') {
                    sh 'vault token renew > /dev/null'
                }
            }
        }
        stage('snap') {
            steps {
                container('vault') {
                    sh 'vault operator raft snapshot save /workdir/vault.snap'
                }
            }
        }
        stage('zip') {
            steps {
                container('ubuntu') {
                    sh 'cd /workdir && tar -czvf vault.snap.tar.gz vault.snap'
                }
            }
        }
        stage('upload') {
            steps {
                container('awscli') {
                    sh '''
                    OBJECT_KEY=$(cat /workdir/object_key)
                    aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/vault.snap.tar.gz
                    '''
                    echo "upload completed"
                    sh 'echo yes > /workdir/ruok'
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