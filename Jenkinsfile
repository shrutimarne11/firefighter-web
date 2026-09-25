pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-2'
        ECR_REGISTRY = '224039895970.dkr.ecr.eu-west-2.amazonaws.com'
        ECR_REPOSITORY = 'firefighter-web'
        EKS_CLUSTER = 'firefighter-eks'
        K8S_NAMESPACE = 'firefighter'
        DEPLOYMENT = 'firefighter-web'
        CONTAINER_NAME = 'firefighter-web'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                      --region ${AWS_REGION} |
                    docker login \
                      --username AWS \
                      --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    docker push \
                      ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER}

                    kubectl -n ${K8S_NAMESPACE} \
                      set image deployment/${DEPLOYMENT} \
                      ${CONTAINER_NAME}=${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl -n ${K8S_NAMESPACE} \
                      rollout status deployment/${DEPLOYMENT} \
                      --timeout=5m
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD deployment completed successfully!'
        }

        failure {
            echo 'CI/CD pipeline failed.'
        }
    }
}
