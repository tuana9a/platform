pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '3')) }
    agent {
        kubernetes {
            yamlFile '.jenkins/vault-unseal.yaml'
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
                    sh 'ls -lha /var/secrets/'
                }
            }
        }
        stage('unseal') {
            steps {
                container('vault') {
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
                                    // Agent for the parallel task
                                    container('vault') { 
                                        sh '''
                                        set +x
                                        export VAULT_ADDR=http://''' + pod + '''.vault-internal.vault.svc.cluster.local:8200
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
                MSG="$status_msg \\`vault-unseal\\` \\`$(($DURATION / 60))m$(($DURATION % 60))s\\` $BUILD_URL"
                if [ -f /var/secrets/DISCORD_WEBHOOK ]; then
                    curl -sS -X POST "$(cat /var/secrets/DISCORD_WEBHOOK)" -H "Content-Type: application/json" -d "{\\"content\\":\\"${MSG}\\"}";
                fi
                '''
            }
        }
    }
}
