node {
    def app
    echo "${environment.HOST_IP}"
    echo "${env.HOST_IP}"
    echo "${withEnv.HOST_IP}"
    sh 'echo ${HOST_IP}'
    sh 'env'


    stage('Clone repository') {
        sh "echo '${env.HOST_IP}'"
        checkout scm
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
          app = docker.build('webapp')
          app.tag("${env.BUILD_NUMBER}")
        }
    }

    stage('Run test-cases') {
          app.inside {
            sh 'cd /webapp && /webapp/bin/rails test'
          }
    }

    stage('Run http test') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image('webapp:latest').withRun('-p 3000:3000') {c ->
                sleep 3
                sh 'curl http://10.67.228.80:3000 &> /dev/null'
            }
         }
    }

  stage('Push image') {
        docker.withRegistry('https://10.67.228.80:5000', '') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
