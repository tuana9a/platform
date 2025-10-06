pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    triggers { cron('0 0 * * *') }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: ubuntu
      image: tuana9a/ubuntu:git-1d3169e
      command: ["sleep", "infinity"]
      envFrom:
        - secretRef:
            name: vault-backup
      volumeMounts:
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
        - name: workdir
          mountPath: "/workdir"
    - name: vault
      image: hashicorp/vault:1.17.2
      command: ["sleep", "infinity"]
      envFrom:
        - secretRef:
            name: vault-backup
      volumeMounts:
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
        - name: workdir
          mountPath: "/workdir"
    - name: awscli
      image: amazon/aws-cli:2.18.0
      command:
        - sleep
      args:
        - infinity
      envFrom:
        - secretRef:
            name: vault-backup
      volumeMounts:
        - name: workdir
          mountPath: /workdir
  volumes:
    - name: secrets
      secret:
        secretName: vault-backup
    - name: workdir
      emptyDir: {}
'''
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
                    "yes") status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`vault-backup\\` \\`$OBJECT_KEY\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                if [ -f /var/secrets/DISCORD_WEBHOOK ]; then
                    curl -X POST "$(cat /var/secrets/DISCORD_WEBHOOK)" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}";
                fi
                '''
            }
        }
    }
}