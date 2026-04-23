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
                script {
                    env.JOB_STATUS = "start"
                    env.START_TIME = sh(script: "date +%s", returnStdout: true).trim()
                    env.BACKUP_DATE = sh(script: "date +%Y/%m/%d", returnStdout: true).trim()
                    env.S3_OBJECT_KEY = "coder-db/${env.BACKUP_DATE}/dump.sql.tar.gz"
                }
                echo "${env.START_TIME} ${env.BACKUP_DATE} ${env.S3_OBJECT_KEY}"
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
                        aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $S3_OBJECT_KEY --body /workdir/dump.sql.tar.gz
                        '''
                    }
                    echo "completed"
                    script {
                        env.JOB_STATUS = "completed"
                    }
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
                file(credentialsId: 'backup-coder-db.env', variable: 'BACKUP_CODER_DB_ENV_FILE')
            ]) {
                script {
                    env.STOP_TIME = sh(script: "date +%s", returnStdout: true).trim()
                    env.DURATION = env.STOP_TIME.toLong() - env.START_TIME.toLong()
                    echo "${env.STOP_TIME} - ${env.START_TIME} = ${env.DURATION}"
                }
                sh '''
                set +x
                . $BACKUP_CODER_DB_ENV_FILE
                case "$JOB_STATUS" in
                    "completed") status_msg="ok" ;;
                    *) status_msg="fuck" ;;
                esac
                MSG="$status_msg backup-coder-db $JOB_STATUS $(($DURATION / 60))m$(($DURATION % 60))s $BUILD_URL $S3_OBJECT_KEY"
                set +x
                curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                    -d chat_id="$TELEGRAM_CHAT_ID" \
                    -d text="$MSG"
                '''
                sh '''
                set +x
                . $BACKUP_CODER_DB_ENV_FILE
                cat << EOF > /workdir/backup.metrics
# TYPE postgres_backup_duration gauge
postgres_backup_duration{host="$PG_HOST", database="$PG_DATABASE"} $DURATION
# TYPE postgres_backup_unixtimestamp gauge
postgres_backup_unixtimestamp{host="$PG_HOST", database="$PG_DATABASE"} $STOP_TIME
EOF
                cat /workdir/backup.metrics
                push_gateway_baseurl="http://prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl -sS --data-binary "@/workdir/backup.metrics" $push_gateway_baseurl/metrics/job/postgres_backup_cronjob
                '''
            }
        }
    }
}