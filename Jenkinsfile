pipeline {
  agent any

  environment {
    EC2_HOST = '54.169.234.169'      
    SSH_CREDENTIALS = '6773bb83-950f-46e9-a35a-8eb08fa1e20f'
    IMAGE_NAME = 'ec2-nginx-app:latest'
  }

  stages {
    stage('Clone code') {
      steps {
        git url: 'https://github.com/ruben-cardoso1/testDockerfile.git'
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
