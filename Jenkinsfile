pipeline {
    agent any
    
    environment {
        // Set your AWS credentials here. Make sure to configure these in Jenkins as environment variables.
        AWS_ACCOUNT_ID        = '110828812774'
        AWS_DEFAULT_REGION    = 'us-east-1'
        ECR_REPOSITORY        = 'public.ecr.aws/l5l8z6i3/panayadb' // Replace with your ECR repository name
        DOCKER_IMAGE_NAME     = 'panayadb' // Replace with your desired Docker image name
        DOCKER_IMAGE_TAG      = 'latest' // Replace with your desired Docker image tag
    }
    
    stages {
        stage('Checkout SCM') {
            steps {
                git "https://github.com/jonspandorf/panaya_project.git"
            }
        }
        stage('docker login') {
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 110828812774.dkr.ecr.us-east-1.amazonaws.com"
            }
        }
        
        stage('build image') {
            steps {
                 sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ./mysql"
            }
        }
        stage('ECR Tag and push') {
            steps {
                sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_REPOSITORY}"
                sh "docker push ${ECR_REPOSITORY}"
            }
        }
    }
}
