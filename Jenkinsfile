node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
          app = docker.build('webapp')
          app.inside {
            sh 'cd /webapp && /webapp/bin/rails test'
          }
        }
    }

    stage('Test image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image('webapp:latest').withRun('-p 9081:80') {c ->
                sh 'curl localhost:9081'
            }
         }
    }

    stage('Push image') {
        docker.withRegistry('10.67.228.80:5000', '') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
