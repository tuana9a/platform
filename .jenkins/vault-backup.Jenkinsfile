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
      image: ubuntu
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
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                container('ubuntu') {
                    sh 'date +%s > /workdir/start.time'
                    sh 'echo 0 > /workdir/status'
                    sh 'OBJECT_KEY=$(date +"%Y%m%d%H")-vault.snapshot.tar.gz && echo $OBJECT_KEY > /workdir/object_key.env'
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
                    sh 'cat /workdir/start.time'
                    sh 'ls -lha /workdir/'
                }
            }
        }
        stage('renew') {
            steps {
                container('vault') {
                    sh '''
                    export VAULT_ADDR=http://vault-active.vault.svc.cluster.local:8200
                    vault token renew > /dev/null
                    '''
                }
            }
        }
        stage('snap') {
            steps {
                container('vault') {
                    sh '''
                    export VAULT_ADDR=http://vault-active.vault.svc.cluster.local:8200
                    vault operator raft snapshot save /workdir/vault.snap
                    '''
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
                    OBJECT_KEY=$(cat /workdir/object_key.env)
                    aws s3api --endpoint-url ${S3_ENDPOINT} put-object --bucket ${BUCKET_NAME} --key $OBJECT_KEY --body /workdir/vault.snap.tar.gz
                    echo upload completed
                    '''
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
                MSG="$status_msg \\`vault-backup\\` \\`$OBJECT_KEY\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                if [ -f /var/secrets/DISCORD_WEBHOOK ]; then
                    curl -X POST "$(cat /var/secrets/DISCORD_WEBHOOK)" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}";
                fi
                '''
            }
        }
    }
}