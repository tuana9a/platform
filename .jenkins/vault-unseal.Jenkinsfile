pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '7')) }
    // triggers { cron('*/5 * * * *') }
    agent {
        kubernetes {
            yamlFile '.jenkins/ubuntu-pod.yml'
            defaultContainer 'ubuntu'
        }
    }
    stages {
        stage('prepare') {
            steps {
                echo 'set-params'
                sh 'date +%s > /workdir/start.time'
                sh 'echo 0 > /workdir/status'
                sh 'echo "noaction" > /workdir/actioned'
            }
        }
        stage('debug') {
            steps {
                sh 'cat /workdir/start.time'
                sh 'ls -lha /workdir/'
            }
        }
        stage('unseal') {
            steps {
                script {
                    // Define the list of items to parallelize over
                    def pods = ["vault-0", "vault-1", "vault-2"]

                    // Create a map of parallel tasks
                    def tasks = pods.collectEntries { pod ->
                        // Alias the loop variable to avoid closure binding issues
                        def currentPod = pod

                        // Map key is the branch name, value is the closure
                        ["unseal ${pod}": {
                            stage("unseal ${pod}") {
                                withCredentials([
                                    file(credentialsId: 'vault-unseal-keys.env', variable: 'VAULT_UNSEAL_ENV_FILE')
                                ]) {
                                    sh '''
                                    set +x
                                    . $VAULT_UNSEAL_ENV_FILE
                                    export VAULT_ADDR=http://''' + pod + '''.vault-internal.vault.svc.cluster.local:8200
                                    echo "VAULT_ADDR=$VAULT_ADDR"
                                    is_sealed=$(curl -sS "$VAULT_ADDR/v1/sys/health" | jq -r '.sealed')
                                    if [ "$is_sealed" = "false" ]; then
                                        echo "unsealed"
                                        echo "noaction"
                                        exit 0
                                    fi
                                    echo "sealed"
                                    echo "unseal"
                                    curl -sS --request POST --data '{"key": "'$unseal_key_0'"}' "$VAULT_ADDR/v1/sys/unseal"
                                    curl -sS --request POST --data '{"key": "'$unseal_key_1'"}' "$VAULT_ADDR/v1/sys/unseal"
                                    curl -sS --request POST --data '{"key": "'$unseal_key_2'"}' "$VAULT_ADDR/v1/sys/unseal"
                                    echo "unsealed" > /workdir/actioned
                                    '''
                                }
                            }
                        }]
                    }
                    // Execute the tasks in parallel
                    parallel tasks
                }
                sh 'echo 1 > /workdir/status'
                sh 'date +%s > /workdir/stop.time'
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
            withCredentials([
                string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'TELEGRAM_CHAT_ID'),
                string(credentialsId: 'TELEGRAM_BOT_TOKEN', variable: 'TELEGRAM_BOT_TOKEN'),
            ]) {
                sh '''
                START_TIME=$(cat "/workdir/start.time")
                STOP_TIME=$(cat "/workdir/stop.time")
                DURATION=$((STOP_TIME - START_TIME))
                actioned="$(cat /workdir/actioned)"
                case "$(cat /workdir/status)" in
                    1) status_msg="ok" ;;
                    *) status_msg="fuck" ;;
                esac
                MSG="$status_msg vault-unseal $actioned $(($DURATION / 60))m$(($DURATION % 60))s $BUILD_URL"
                curl -sS -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                    -d chat_id="$TELEGRAM_CHAT_ID" \
                    -d text="$MSG"
                '''
            }
        }
    }
}
