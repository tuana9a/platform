pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            yamlFile '.jenkins/podTemplate/502-coder-postgres-backup.yml'
            defaultContainer 'shell'
            retries 2
        }
    }
    stages {
        stage('set-params') {
            steps {
                container('set-params') {
                    sh 'OBJECT_KEY="$(date +%Y%m%d%H)-coder-postgres-dump.sql.tar.gz" && echo $OBJECT_KEY > /workdir/object_key.env'
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo 0 > /workdir/status'
                    sh 'ls -lha /workdir/'
                    sh 'cat /workdir/start.time'
                    sh 'cat /workdir/object_key.env'
                }
            }
        }
        stage('dump') {
            steps {
                container('dump') {
                    sh 'export PGPASSWORD=$PG_PASS; pg_dump --no-owner -v -h $PG_HOST -p ${PG_PORT:-5432} -U $PG_USER -d $PG_DATABASE > /workdir/dump.sql'
                    sh 'ls -lha /workdir/'
                }
            }
        }
        stage('zip') {
            steps {
                container('zip') {
                    sh 'cd /workdir && tar -czvf dump.sql.tar.gz dump.sql'
                    sh 'ls -lha /workdir/'
                }
            }
        }
        stage('upload') {
            steps {
                container('upload') {
                    sh 'OBJECT_KEY=$(cat /workdir/object_key.env) && aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/dump.sql.tar.gz'
                    sh 'echo upload completed'
                    sh 'date +%s > /workdir/stop.time'
                    sh 'ls -lha /workdir/'
                    sh 'cat /workdir/stop.time'
                    sh 'echo 1 > /workdir/status'
                }
            }
        }
        stage('finally') {
            steps {
                container('ubuntu') {
                    echo 'dummy'
                }
            }
        }
    }
    post {
        always {
            container('notify') {
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /workdir/object_key.env)
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`backup-postgres\\` \\`coder\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
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
                '''
                sh '''
                cat /workdir/backup.metrics
                push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl --data-binary "@/workdir/backup.metrics" $push_gateway_baseurl/metrics/job/postgres_backup_cronjob
                '''
            }
        }
    }
}