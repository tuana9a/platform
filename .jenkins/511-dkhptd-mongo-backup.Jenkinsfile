pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/511-dkhptd-mongo-backup.yml'
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                container('ubuntu') {
                    sh 'OBJECT_KEY=$(date +"%Y%m%d%H")-dkhptd-mongo-dump.tar.gz && echo $OBJECT_KEY > /workdir/object_key.env'
                    sh 'date +%s > /workdir/start.time'
                }
                echo 'install-tools'
                container('ubuntu') {
                    sh 'apt update && apt install -y curl'
                }
            }
        }
        stage('debug') {
            steps {
                container('ubuntu') {
                    sh 'ls -lha /workdir/'
                    sh 'cat /workdir/start.time'
                    sh 'cat /workdir/object_key.env'
                }
            }
        }
        stage('dump') {
            steps {
                container('mongo') {
                    sh 'mongodump --uri=${MONGO_CONNECTION_STRING} --out=/workdir/dump'
                    sh 'ls -lha /workdir/'
                }
            }
        }
        stage('zip') {
            steps {
                container('ubuntu') {
                    sh 'cd /workdir && tar -czvf dump.tar.gz dump'
                    sh 'ls -lha /workdir/'
                }
            }
        }
        stage('upload') {
            steps {
                container('awscli') {
                    sh 'OBJECT_KEY=$(cat /workdir/object_key.env) && aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/dump.tar.gz'
                    sh 'echo upload completed'
                    sh 'date +%s > /workdir/stop.time'
                    sh 'ls -lha /workdir/'
                    sh 'cat /workdir/stop.time'
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
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /workdir/object_key.env)
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`backup-mongo\\` \\`dkhptd\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                '''
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                cat << EOF > /workdir/backup.metrics
# TYPE mongo_backup_duration counter
mongo_backup_duration{namespace="$POD_NAMESPACE"} $DURATION
# TYPE mongo_backup_unixtimestamp gauge
mongo_backup_unixtimestamp{namespace="$POD_NAMESPACE"} $(date +%s)
EOF
                '''
                sh '''
                cat /workdir/backup.metrics
                push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl --data-binary "@/workdir/backup.metrics" $push_gateway_baseurl/metrics/job/mongo_backup_cronjob
                '''
            }
        }
    }
}