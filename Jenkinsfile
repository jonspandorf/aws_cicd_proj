pipeline {
    agent any

    parameters {
        string(name: 'VPC_ID', defaultValue: 'your-vpc-id', description: 'The ID of your VPC')
        string(name: 'ECS_NAME', defaultValue: 'your-ecs-name', description: 'The name of your ECS cluster')
        string(name: 'MYSQL_DB', defaultValue: 'your-mysql-db', description: 'The name of the MySQL database')
        string(name: 'MYSQL_USER', defaultValue: 'your-mysql-user', description: 'The MySQL user')
        string(name: 'MYSQL_PASS', defaultValue: 'your-mysql-pass', description: 'The MySQL password')
    }
    
    environment {
        AWS_REGION             = 'us-east-1'
        ECR_PUBLIC_REPOSITORY  = 'public.ecr.aws/l5l8z6i3' 
        DOCKER_DB_IMAGE_NAME   = 'panayadb' 
        DOCKER_WS_IMAGE_NAME   = 'panaya_webserver'
        DOCKER_IMAGE_TAG       = 'latest' 
    }
    
    stages {
        stage('Checkout SCM') {
            steps {
                git "https://github.com/jonspandorf/panaya_project.git"
            }
        }
        stage('docker login') {
            steps {
                sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/l5l8z6i3"
            }
        }
        stage('build image and push image') {
            steps {
                 sh "docker compose -f docker-compose-build.yaml build panayadb_image"
                 sh "docker compose -f docker-compose-build.yaml push panayadb_image"
            }
        }
        // stage('ECR Tag and push') {
        //     steps {
        //         sh "docker tag ${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_PUBLIC_REPOSITORY}/${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        //         sh "docker push ${ECR_PUBLIC_REPOSITORY}/${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        //     }
        // }
        stage('Prepare DB deploy') {
            steps {
                sh "docker compose run mysql_deploy"
            }
        }
        stage('Get DB Hostname') {
            steps {
                sh 'sleep 30'
                sh 'aws ecs list-tasks --region us-east-1 --cluster my_test_ecs > output.json'
                sh 'aws ecs describe-tasks --region us-east-1 --cluster my_test_ecs --task $(cat output.json | jq -r .taskArns[0]) > output.json'
                sh 'export MYSQL_HOST = $(cat output.json | jq -r .tasks[0].attachments[0].details[-1].value)'
                sh 'rm output.json'
            }
        }
        stage('Build and pushWebserver') {
            steps {
                sh 'docker compose -f docker-compose-build.yaml build frontend_image'
                sh 'docker compose -f docker-compose-build.yaml push frontend_image'
            }
        }
        // stage('Webserver Tag and push') {
        //     steps {
        //         sh "docker tag ${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_PUBLIC_REPOSITORY}/${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        //         sh "docker push ${ECR_PUBLIC_REPOSITORY}/${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        //     }
        // }
        stage('Deploy Webserver') {
            steps {
                sh 'docker compose run webserver_deploy'
            }
        }
    }
}
