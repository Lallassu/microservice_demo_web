node {
    def app

      if (expression {sh(returnStatus: 0, script:"docker service inspect webapp") == 0}) {
          echo "Performing rolling upgrade of service."
      } else {
          echo "Performing deploy of service."
      }

    return

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
            docker.image('webapp:latest').withRun('-p 3000:3000') {c ->
                sleep 3
                sh "curl http://${env.HOST_IP}:3000 &> /dev/null"
            }
         }
    }

  stage('Push image') {
        docker.withRegistry("https://${env.HOST_IP}:5000", '') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

  stage('Deploy To Swarm') {
      // Check if service runs, then perform rolling upgrade, else deploy.
      if (expression{ sh(returnStatus: 0, script: "curl http://${env.HOST_IP} &> /dev/null")}) {
          echo "Performing rolling upgrade of service."
          sh "docker service update --image ${env.HOST_IP}:5000/webapp:latest webapp"
      } else {
          echo "Performing deploy of service."
          sh "docker service create --replicas 2 -p 80:3000 --name webapp ${env.HOST_IP}:5000/webapp:latest"
      }
  }

  stage('Verify Deployment') {
    sh "curl http://${env.HOST_IP}/ &> /dev/null"
  }

}
