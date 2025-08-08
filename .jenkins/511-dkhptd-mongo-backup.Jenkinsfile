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
        stage('set-params') {
            steps {
                container('ubuntu') {
                    sh 'OBJECT_KEY=$(date +"%Y%m%d%H")-dkhptd-mongo-dump.tar.gz && echo $OBJECT_KEY > /data/object_key.env'
                    sh 'date +%s > /data/start.time'
                }
            }
        }
        stage('debug') {
            steps {
                container('ubuntu') {
                    sh 'ls -lha /data/'
                    sh 'cat /data/start.time'
                    sh 'cat /data/object_key.env'
                }
            }
        }
        stage('Install tools') {
            steps {
                container('ubuntu') {
                    sh 'apt update && apt install -y curl'
                }
            }
        }
        stage('dump zip upload') {
            steps {
                container('mongo') {
                    sh 'mongodump --uri=${MONGO_CONNECTION_STRING} --out=/data/dump'
                    sh 'ls -lha /data/'
                }
                container('ubuntu') {
                    sh 'cd /data && tar -czvf dump.tar.gz dump'
                    sh 'ls -lha /data/'
                }
                container('awscli') {
                    sh 'OBJECT_KEY=$(cat /data/object_key.env) && aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /data/dump.tar.gz'
                    sh 'echo upload completed'
                    sh 'date +%s > /data/stop.time'
                    sh 'ls -lha /data/'
                    sh 'cat /data/stop.time'
                    sh 'echo 1 > /data/status'
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
                START_TIME=$(cat "/data/start.time")
                STOP_TIME=$(cat "/data/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                OBJECT_KEY=$(cat /data/object_key.env)
                case "$(cat /data/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`backup-mongo\\` \\`dkhptd\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                curl -X POST "${DISCORD_WEBHOOK}" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}"
                '''
                sh '''
                START_TIME=$(cat "/data/start.time")
                STOP_TIME=$(cat "/data/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                cat << EOF > /data/backup.metrics
# TYPE mongo_backup_duration counter
mongo_backup_duration{namespace="$POD_NAMESPACE"} $DURATION
# TYPE mongo_backup_unixtimestamp gauge
mongo_backup_unixtimestamp{namespace="$POD_NAMESPACE"} $(date +%s)
EOF
                '''
                sh '''
                cat /data/backup.metrics
                push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl --data-binary "@/data/backup.metrics" $push_gateway_baseurl/metrics/job/mongo_backup_cronjob
                '''
            }
        }
    }
}