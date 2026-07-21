pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nest-demo-app:latest'
        CONTAINER_NAME = 'nest-demo-container'
    }

    stages {
        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Deploy') {
            steps {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}"
            }
        }
    }
}
