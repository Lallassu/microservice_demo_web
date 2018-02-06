node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Prepare') {
        sh 'echo "SUCCESS"'
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image('ruby:2.4.1').withRun('-p 9081:80') {c ->
                sh 'echo "SUCCESS DOCKER RUN"'
            }
        }
    }

    stage('Test image') {
        sh 'echo "SUCCESS"'
    }

    stage('Push image') {
        docker.withRegistry('http://10.67.228.80:5000', '') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
