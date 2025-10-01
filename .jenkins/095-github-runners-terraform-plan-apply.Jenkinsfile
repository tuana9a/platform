pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '14')) }
    // triggers {
    //     githubPush()
    // }
    agent any
    stages {
        stage('main') {
            steps {
                build job: 'TerraformPlanApplyNotify/rock-n-roll', propagate: true, wait: true, parameters: [[$class: 'StringParameterValue', name: 'WORKINGDIR', value: "095-github-runners"]]
            }
        }
    }
}