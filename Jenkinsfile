pipeline {
  agent any

  environment {
    EC2_HOST = 'X.X.X.X'           // <-- Remplace avec ton IP publique EC2
    SSH_CREDENTIALS = 'ec2-ssh'    // <-- L'ID du credential Jenkins
    IMAGE_NAME = 'ec2-nginx-app:latest'
  }

  stages {
    stage('Clone code') {
      steps {
        git url: 'https://github.com/<ton-user>/mon-app.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build("${IMAGE_NAME}")
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        sshagent (credentials: ["${SSH_CREDENTIALS}"]) {
          sh """
          ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} '
            docker stop monapp || true
            docker rm monapp || true
            docker run -d -p 80:80 --name monapp ${IMAGE_NAME}
          '
          """
        }
      }
    }
  }
}
