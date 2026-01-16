pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent any
    environment {
        WORKINGDIR = "020-proxmox-cloudimg-neomorph"
    }
    stages {
        stage('main') {
            steps {
                build job: 'tfaa/rock-n-roll', propagate: true, wait: true, parameters: [[$class: 'StringParameterValue', name: 'WORKINGDIR', value: env.WORKINGDIR]]
            }
        }
    }
}