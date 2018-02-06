node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image('ruby:latest').withRun('-p 8080:80') {c ->
                sh "curl -i http://${hostIp(c)}:8080/"
            }
        }
    }

    stage('Test image') {
        app.inside {
            sh 'cd /webapp && rails test'
        }
    }

    stage('Push image') {
        docker.withRegistry('http://10.67.228.80:5000', '') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
