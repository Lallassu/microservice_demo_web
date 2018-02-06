node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
          app = docker.build('webapp')
        }
    }

    stage('Run test-cases') {
          app.inside {
            sh 'cd /webapp && /webapp/bin/rails test'
          }
    }

    stage('Run http test') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image('webapp:latest').withRun('-p 9081:3000') {c ->
                app.inside {
                    sh 'curl http://localhost:3000'
                }
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
