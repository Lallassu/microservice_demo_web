node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        app = docker.build("webapp")
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
