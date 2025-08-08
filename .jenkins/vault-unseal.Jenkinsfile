pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent {
        kubernetes {
            yamlFile '.jenkins/podTemplate/vault-unseal.yml'
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
                    sh 'ls -lha /var/secrets/'
                }
            }
        }
        stage('unseal') {
            steps {
                container('vault') {
                    sh '''
                    for instanceId in $(seq 0 2); do
                        export VAULT_ADDR=http://vault-$instanceId.vault-internal.vault.svc.cluster.local:8200
                        echo "VAULT_ADDR=$VAULT_ADDR"
                        is_sealed=$(vault status | grep -i sealed | awk '{print $2}')
                        if [ "$is_sealed" = "false" ]; then
                            echo "vault is unsealed. Exiting..."
                            continue
                        fi
                        echo "vault is sealed. Unsealing..."
                        vault operator unseal $(cat /var/secrets/unseal_key_0)
                        vault operator unseal $(cat /var/secrets/unseal_key_1)
                        vault operator unseal $(cat /var/secrets/unseal_key_2)
                    done
                    '''
                    sh 'echo 1 > /workdir/status'
                    sh 'date +%s > /workdir/stop.time'
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
                case "$(cat /workdir/status)" in
                    1) status_msg=":white_check_mark:" ;;
                    *) status_msg=":x:" ;;
                esac
                MSG="$status_msg \\`vault-unseal\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\`"
                if [ -f /var/secrets/DISCORD_WEBHOOK ]; then
                    curl -X POST "$(cat /var/secrets/DISCORD_WEBHOOK)" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}";
                fi
                '''
            }
        }
    }
}
