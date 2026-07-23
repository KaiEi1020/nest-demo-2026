pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nest-demo-app'
        // 动态版本：构建号 + 短 commit hash，例如 12-a1b2c3d
        IMAGE_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT?.take(7) ?: 'local'}"
        CONTAINER_NAME = 'nest-demo-container'
        // 阿里云个人版 ACR
        ACR_REGISTRY = 'crpi-iao9ofa54ta9eu5t.cn-hangzhou.personal.cr.aliyuncs.com'
        // 在 ACR 控制台创建的命名空间，按实际修改
        ACR_NAMESPACE = 'lethe1020'
        ACR_IMAGE = "${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}"
    }

    stages {
        stage('Build Image') {
            steps {
                sh "docker buildx build --platform linux/amd64 --load -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Docker Login & Push') {
            steps {
                // Jenkins 配置 credentialsId: aliyun-acr-token（用户名 lethe1213 + ACR 密码/Token）
                withCredentials([usernamePassword(credentialsId: 'aliyun-acr-token',
                                                  usernameVariable: 'ACR_USER',
                                                  passwordVariable: 'ACR_PASS')]) {
                    sh "docker login --username=${ACR_USER} --password=${ACR_PASS} ${ACR_REGISTRY}"
                    // 推送唯一版本标签 + latest（方便回滚与默认拉取）
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ACR_IMAGE}:${IMAGE_TAG}"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ACR_IMAGE}:latest"
                    sh "docker push ${ACR_IMAGE}:${IMAGE_TAG}"
                    sh "docker push ${ACR_IMAGE}:latest"
                }
            }
            post {
                always {
                    // 推送完成后登出，避免凭据残留在构建节点
                    sh "docker logout ${ACR_REGISTRY} || true"
                }
            }
        }

        // stage('Deploy') {
        //     steps {
        //         sh "docker stop ${CONTAINER_NAME} || true"
        //         sh "docker rm ${CONTAINER_NAME} || true"
        //         // 使用本次建的唯一版本部署，避免 latest 缓存问题
        //         sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${ACR_IMAGE}:${IMAGE_TAG}"
        //     }
        // }
    }

    post {
        always {
            // 清理虚悬镜像，释放磁盘空间
            sh 'docker image prune -f || true'
        }
    }
}
