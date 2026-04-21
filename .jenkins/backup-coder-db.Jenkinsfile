pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 17 * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/backup-coder-db.yml'
            defaultContainer 'ubuntu'
        }
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                sh 'date +%s > /workdir/start.time'
                sh 'echo 0 > /workdir/status'
                sh 'OBJECT_KEY="coder-db/$(date +%Y%m%d%H)/dump.sql.tar.gz" && echo $OBJECT_KEY > /workdir/object_key.env'
                sh 'ls -lha /workdir/'
                sh 'cat /workdir/start.time'
                sh 'cat /workdir/object_key.env'
            }
        }
        stage('backup') {
            steps {
                withCredentials([
                    file(credentialsId: 'backup-coder-db.env', variable: 'BACKUP_CODER_DB_ENV_FILE')
                ]) {
                    echo "dump"
                    container("postgres") {
                        sh '''
                        set +x
                        . $BACKUP_CODER_DB_ENV_FILE
                        export PGPASSWORD=$PG_PASS
                        pg_dump --no-owner -v -h $PG_HOST -p ${PG_PORT:-5432} -U $PG_USER -d $PG_DATABASE > /workdir/dump.sql
                        '''
                    }
                    sh 'ls -lha /workdir/'

                    echo "zip"
                    sh 'cd /workdir && tar -czvf dump.sql.tar.gz dump.sql'
                    sh 'ls -lha /workdir/'

                    echo "upload"
                    container("awscli") {
                        sh '''
                        set +x
                        . $BACKUP_CODER_DB_ENV_FILE
                        OBJECT_KEY=$(cat /workdir/object_key.env)
                        aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/dump.sql.tar.gz
                        '''
                    }
                    sh 'echo 1 > /workdir/status'
                    sh 'echo upload completed'
                }
            }
        }
        stage('finally') {
            steps {
                echo 'dummy'
            }
        }
    }
    post {
        always {
            withCredentials([
                string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'TELEGRAM_CHAT_ID'),
                string(credentialsId: 'TELEGRAM_BOT_TOKEN', variable: 'TELEGRAM_BOT_TOKEN'),
            ]) {
                sh 'date +%s > /workdir/stop.time'
                sh '''
                set +x
                . $BACKUP_CODER_DB_ENV_FILE
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /workdir/object_key.env)
                case "$(cat /workdir/status)" in
                    1) status_msg="ok" ;;
                    *) status_msg="fuck" ;;
                esac
                MSG="$status_msg backup-coder-db $OBJECT_KEY $(($DURATION / 60))m$(($DURATION % 60))s $BUILD_URL"
                set +x
                curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                    -d chat_id="$TELEGRAM_CHAT_ID" \
                    -d text="$MSG"
                '''
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                cat << EOF > /workdir/backup.metrics
# TYPE postgres_backup_duration gauge
postgres_backup_duration{namespace="$POD_NAMESPACE"} $DURATION
# TYPE postgres_backup_unixtimestamp gauge
postgres_backup_unixtimestamp{namespace="$POD_NAMESPACE"} $(date +%s)
EOF
                cat /workdir/backup.metrics
                push_gateway_baseurl="http://prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl -sS --data-binary "@/workdir/backup.metrics" $push_gateway_baseurl/metrics/job/postgres_backup_cronjob
                '''
            }
        }
    }
}