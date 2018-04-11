node {
    def app

    stage('Clone repository') {
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
            docker.image("webapp:${env.BUILD_NUMBER}").withRun('-p 3000:3000') {c ->
                sleep 3
                sh "curl http://${env.HOST_IP}:3000 &> /dev/null"
            }
         }
    }

  stage('Push image') {
        docker.withRegistry("https://${env.HOST_IP}:5000", '') {
            app.push("${env.BUILD_NUMBER}")
        }
    }

  stage('Deploy To Swarm') {
      // Check if service runs, then perform rolling upgrade, else deploy.
      if (sh(returnStatus: true, script: "docker service inspect webapp") == 0) {
          echo "Performing rolling upgrade of service."
          sh "docker service update --env-add HOST_IP=${env.HOST_IP} --image ${env.HOST_IP}:5000/webapp:${env.BUILD_NUMBER} webapp"
      } else {
          echo "Performing deploy of service."
          sh "docker service create -e HOST_IP=${env.HOST_IP} --replicas 1 -p 80:3000 --name webapp ${env.HOST_IP}:5000/webapp:${env.BUILD_NUMBER}"
      }
  }

  stage('Verify Deployment') {
    sh "curl http://${env.HOST_IP}/ &> /dev/null"
  }

}
