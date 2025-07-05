pipeline {
  agent any

  environment {
    EC2_HOST = '3.26.26.197'      
    SSH_CREDENTIALS = 'ec2_jenkins'
    IMAGE_NAME = 'ec2-nginx-app:latest'
  }

  stages {
    stage('Clone code') {
      steps {
        git url: 'https://github.com/ruben-cardoso1/testDockerfile.git'
      }
    }
  stage('Check Docker Access') {
    steps {
      sh 'whoami'
    }
  }
    stage('install Docker into container') {
    steps {
      sh 'sudo apt update -y'
      sh 'sudo apt install docker.io -y'
      sh 'sudo systemctl start docker'
      sh 'sudo usermod -aG docker jenkins'
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
          ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
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
