pipeline {
  parameters {
    password(name: 'PASSWORD', defaultValue: 'youshouldntseethis')
  }
  environment {
    PASSWORD = "${params.PASSWORD}"
  }
  agent any
  stages {
    stage('param ❌') {
      steps {
        sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${params.PASSWORD}"
      }
    }
    stage('env variable ❌') {
      steps {
        sh 'curl -X PUT https://paste.tuana9a.com/text/password -H "Content-Type: text/plain" -d $PASSWORD'
      }
    }
    stage('groovy variable ❌') {
      steps {
        script {
          def password = params.PASSWORD
          sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${password}"
        }
      }
    }
    stage('mask plugin ✅') {
      steps {
        script {
          wrap([$class: 'MaskPasswordsBuildWrapper', varPasswordPairs: [[password: params.PASSWORD, var: 'password']]]) {
            sh "curl -X PUT https://paste.tuana9a.com/text/password -H \"Content-Type: text/plain\" -d ${password}"
          }
        }
      }
    }
  }
}