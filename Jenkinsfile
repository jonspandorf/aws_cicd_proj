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
        ECR_DB_REPOSITORY      = 'public.ecr.aws/l5l8z6i3' 
        ECR_WS_REPOSITORY      = 'public.ecr.aws/l5l8z6i3/panayadb:latest'
        DOCKER_DB_IMAGE_NAME   = 'panayadb' 
        DOCKER_WS_IMAGE_NAME   = 'panaya_frontend'
        DOCKER_IMAGE_TAG       = 'latest' 
        JENKINS_CONTAINER_NAME = 'sweet_ganguly' 
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
        stage('build image') {
            steps {
                 sh "ls -lhtr"
                 sh "docker build -t ${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ./mysql"
            }
        }
        stage('ECR Tag and push') {
            steps {
                sh "docker tag ${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_DB_REPOSITORY}/${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                sh "docker push ${ECR_DB_REPOSITORY}/${DOCKER_DB_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
            }
        }
        stage('Deploy DB') {
            steps {
                sh "echo $PWD"
                sh "docker run --rm --volumes-from ${JENKINS_CONTAINER_NAME} hashicorp/terraform -chdir=./mysql init"
                sh "docker run --rm --volumes-from ${JENKINS_CONTAINER_NAME} hashicorp/terraform -chdir=./mysql apply -var VPC_ID=${param.VPC_ID} -var ECS_NAME=${param.ECS_NAME} -var MYSQL_DATABASE=${param.MYSQL_DB} -var MYSQL_ROOT_PASSWORD=${param.MYSQL_PASS} -auto-approve "
            }
        }
        stage('DB Metadata') {
            steps {
                sh 'aws ecs describe-tasks --region us-east-1 --cluster my_test_ecs --task $(jq -r .taskArns[0]) > output.json'
                sh 'aws ecs describe-tasks --region us-east-1 --cluster my_test_ecs --task $(cat output.json | jq -r .taskArns[0]) > output.json'
                sh 'cat output.json | jq -r .tasks[0].attachments[0].details[-1].value > dbPrivateIp.txt'
                sh 'rm output.json'
            }
        }
        stage('Build Webserver') {
            steps {
                sh 'docker build -t ${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG} --build-arg MYSQL_DB=$(cat dbPrivateIp.txt) --build-arg MYSQL_USER=${MYSQL_USER} --build-arg MYSQL_PASS=${MYSQL_PASS} --build-arg MYSQL_DB=${MYSQL_DB} ./webserver'
            }
        }
        stage('Webserver Tag and push') {
            steps {
                sh "docker tag ${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ECR_WS_REPOSITORY}/${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                sh "docker push ${ECR_WS_REPOSITORY}/${DOCKER_WS_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
            }
        }
        stage('Deploy WS') {
            steps {
                sh "docker run --rm --volumes-from ${JENKINS_CONTAINER_NAME} -w $PWD hashicorp/terraform -chdir=./webserver init"
                sh "docker run --rm --volumes-from ${JENKINS_CONTAINER_NAME} -w $PWD hashicorp/terraform -chdir=./webserver apply -var VPC_ID=${param.VPC_ID} -var ECS_NAME=${param.ECS_NAME} -auto-approve"
            }
        }
    }
}
