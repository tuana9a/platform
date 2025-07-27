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
                    sh 'OBJECT_KEY="$(date +%Y%m%d%H)-coder-postgres-dump.sql.tar.gz" && echo $OBJECT_KEY > /data/object_key.env'
                    sh 'date +%s > /data/start.time'
                    sh 'ls -lha /data/'
                    sh 'cat /data/start.time'
                    sh 'cat /data/object_key.env'
                }
            }
        }
        stage('dump zip upload') {
            steps {
                container('dump') {
                    sh 'export PGPASSWORD=$PG_PASS; pg_dump --no-owner -v -h $PG_HOST -p ${PG_PORT:-5432} -U $PG_USER -d $PG_DATABASE > /data/dump.sql'
                    sh 'ls -lha /data/'
                }
                container('zip') {
                    sh 'cd /data && tar -czvf dump.sql.tar.gz dump.sql'
                    sh 'ls -lha /data/'
                }
                container('upload') {
                    sh 'OBJECT_KEY=$(cat /data/object_key.env) && aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /data/dump.sql.tar.gz'
                    sh 'echo upload completed'
                    sh 'date +%s > /data/stop.time'
                    sh 'ls -lha /data/'
                    sh 'cat /data/stop.time'
                    sh 'echo 1 > /data/status'
                }
            }
        }
    }
    post {
        always {
            container('notify') {
                sh '''
                START_TIME=$(cat "/data/start.time")
                STOP_TIME=$(cat "/data/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /data/object_key.env)
                case "$(cat /data/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`backup-postgres\\` \\`coder\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                '''
                sh '''
                START_TIME=$(cat "/data/start.time")
                STOP_TIME=$(cat "/data/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                cat << EOF > /data/backup.metrics
# TYPE postgres_backup_duration gauge
postgres_backup_duration{namespace="$POD_NAMESPACE"} $DURATION
# TYPE postgres_backup_unixtimestamp gauge
postgres_backup_unixtimestamp{namespace="$POD_NAMESPACE"} $(date +%s)
EOF
                '''
                sh '''
                cat /data/backup.metrics
                push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl --data-binary "@/data/backup.metrics" $push_gateway_baseurl/metrics/job/postgres_backup_cronjob
                '''
            }
        }
    }
}