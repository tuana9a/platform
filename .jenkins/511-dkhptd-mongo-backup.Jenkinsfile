pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: ubuntu
      image: tuana9a/ubuntu:git-1d3169e
      command:
        - sleep
      args:
        - infinity
      env:
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      envFrom:
        - secretRef:
            name: 511-dkhptd-mongo-backup-env
      volumeMounts:
        - name: workdir
          mountPath: /workdir

    - name: mongo
      image: mongo:4.4
      command:
        - sleep
      args:
        - infinity
      volumeMounts:
        - name: workdir
          mountPath: /workdir
      envFrom:
        - secretRef:
            name: 511-dkhptd-mongo-backup-env

    - name: awscli
      image: amazon/aws-cli:2.18.0
      command:
        - sleep
      args:
        - infinity
      envFrom:
        - secretRef:
            name: 511-dkhptd-mongo-backup-env
      volumeMounts:
        - name: workdir
          mountPath: /workdir

  restartPolicy: Never
  volumes:
    - name: workdir
      emptyDir: {}
'''
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                container('ubuntu') {
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo 0 > /workdir/status'
                    sh 'OBJECT_KEY=$(date +"%Y%m%d%H")-dkhptd-mongo-dump.tar.gz && echo $OBJECT_KEY > /workdir/object_key.env'
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
                    sh 'echo 1 > /workdir/status'
                    sh 'echo upload completed'
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
                OBJECT_KEY=$(cat /workdir/object_key.env)
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`backup-mongo\\` \\`dkhptd\\` \\`$OBJECT_KEY\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
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
                cat /workdir/backup.metrics
                push_gateway_baseurl="http://prometheus-prometheus-pushgateway.prometheus.svc.cluster.local:9091"
                curl --data-binary "@/workdir/backup.metrics" $push_gateway_baseurl/metrics/job/mongo_backup_cronjob
                '''
            }
        }
    }
}