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
      volumeMounts:
        - name: workdir
          mountPath: "/workdir"
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
    - name: vault
      image: hashicorp/vault:1.17.2
      command: ["sleep", "infinity"]
      envFrom:
        - secretRef:
            name: vault-secret-store-token-renew
      volumeMounts:
        - name: workdir
          mountPath: "/workdir"
        - name: secrets
          mountPath: "/var/secrets"
          readOnly: true
  volumes:
    - name: workdir
      emptyDir: {}
    - name: secrets
      secret:
        secretName: vault-secret-store-token-renew
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
                    set +x
                    export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
                    export VAULT_TOKEN=$(cat /var/secrets/token)
                    vault token renew > /dev/null
                    '''
                    sh 'echo 1 > /workdir/status'
                }
            }
        }
        stage('finally') {
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
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`vault-secret-store-token-renew\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                if [ -f /var/secrets/DISCORD_WEBHOOK ]; then
                    curl -X POST "$(cat /var/secrets/DISCORD_WEBHOOK)" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}";
                fi
                '''
            }
        }
    }
}