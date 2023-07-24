pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID        = '110828812774'
        AWS_REGION            = 'us-east-1'
        ECR_REPOSITORY        = 'public.ecr.aws/l5l8z6i3' 
        DOCKER_IMAGE_NAME     = 'panayadb' 
        DOCKER_IMAGE_TAG      = 'latest' 
    }
    
    stages {
        stage('Checkout SCM') {
            steps {
                git "https://github.com/jonspandorf/panaya_project.git"
            }
        }
        stage('docker login') {
            steps {
                sh "aws ecr-public get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin public.ecr.aws/l5l8z6i3"
            }
        }
        
        stage('build image') {
            steps {
                 sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ./mysql"
            }
        }
        stage('ECR Tag and push') {
            steps {
                sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                sh "docker push ${ECR_REPOSITORY}"
            }
        }
    }
}
