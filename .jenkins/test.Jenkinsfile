pipeline {
  parameters {
    password(name: 'PASSWORD', defaultValue: 'youshouldntseethis')
  }
  environment {
    PASSWORD = "${params.PASSWORD}"
  }
  agent any
  stages {
    stage('param password is not masked by default') {
      steps {
        sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${params.PASSWORD}"
      }
    }
    stage('set it into env variable doesn\'t help also') {
      steps {
        sh 'curl -X PUT https://paste.tuana9a.com/text/password -H "Content-Type: text/plain" -d $PASSWORD'
      }
    }
    stage('set it to a groovy variable doesn\'t help also') {
      steps {
        script {
          def password = params.PASSWORD
          sh "curl -X PUT https://paste.tuana9a.com/text/password -H 'Content-Type: text/plain' -d ${password}"
        }
      }
    }
    stage('using a wrap mask password would help') {
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