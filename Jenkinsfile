pipeline {
  agent any

  environment {
    EC2_HOST = '54.255.211.203'      
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
    stage('Check Docker running') {
    steps {
      sh 'docker ps'
    }
  }
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ec2-nginx-app:latest .'
      }
    }

    stage('Export Docker Image') {
      steps {
        sh 'docker save -o image.tar ec2-nginx-app:latest'
      }
    }

    stage('Transfer and Deploy on EC2') {
      steps {
        sshagent (credentials: ["${SSH_CREDENTIALS}"]) {
          sh """
            scp -o StrictHostKeyChecking=no image.tar ubuntu@${EC2_HOST}:/tmp/
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
              docker load -i /tmp/image.tar
              docker stop monapp || true
              docker rm monapp || true
              docker run -d -p 80:80 --name monapp ec2-nginx-app:latest
            '
          """
        }
      }
    }
  }
}
