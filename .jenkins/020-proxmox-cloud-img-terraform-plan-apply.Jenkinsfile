pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    agent any
    environment {
        WORKINGDIR = "020-proxmox-cloud-img"
    }
    stages {
        stage('main') {
            steps {
                build job: 'TerraformPlanApplyNotify/rock-n-roll', propagate: true, wait: true, parameters: [[$class: 'StringParameterValue', name: 'WORKINGDIR', value: env.WORKINGDIR]]
            }
        }
    }
}