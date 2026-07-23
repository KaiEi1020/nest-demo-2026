@Library('pipeline-lib') _

dockerAckDeployFromGit(
    repoUrl: 'https://github.com/KaiEi1020/nest-demo-2026.git',
    acrRegistry: 'crpi-iao9ofa54ta9eu5t.cn-hangzhou.personal.cr.aliyuncs.com',
    acrNamespace: 'lethe1020',
    acrCredentialId: 'aliyun-acr-token',
    kubeconfigCredentialId: 'ack-kubeconfig',
    // 镜像名（默认取 JOB_NAME，这里显式指定，避免依赖 Job 命名约定）
    imageName: 'nest-demo-app',
    // 必须与集群中实际的 Deployment 名一致
    k8sDeployment: 'my-web-app',
    // Deployment 里的容器名（库默认就是 web，显式写出更稳）
    k8sContainer: 'web',
    // 部署目标 namespace（与 acr-secret 所在 namespace 保持一致）
    k8sNamespace: 'default'
)