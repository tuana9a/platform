pipeline {
  parameters {
    password(name: 'PASSWORD', defaultValue: 'youshouldntseethis')
  }
  environment {
    PASSWORD = "${params.PASSWORD}"
  }
  agent any
  stages {
    stage('(x) param password') {
      steps {
        sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${params.PASSWORD}"
      }
    }
    stage('(x) env variable') {
      steps {
        sh 'curl -X PUT https://paste.tuana9a.com/text/password -H "Content-Type: text/plain" -d $PASSWORD'
      }
    }
    stage('(x) groovy variable') {
      steps {
        script {
          def password = params.PASSWORD
          sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${password}"
        }
      }
    }
    stage('(v) wrap mask password') {
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