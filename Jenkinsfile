pipeline {
    agent any

    parameters {
        string(name: 'VPC_ID', defaultValue: 'your-vpc-id', description: 'The ID of your VPC')
        string(name: 'ECS_NAME', defaultValue: 'your-ecs-name', description: 'The name of your ECS cluster')
        string(name: 'MYSQL_DB', defaultValue: 'your-mysql-db', description: 'The name of the MySQL database')
        string(name: 'MYSQL_USER', defaultValue: 'your-mysql-user', description: 'The MySQL user')
        string(name: 'MYSQL_PASS', defaultValue: 'your-mysql-pass', description: 'The MySQL password')
        string(name: 'ECR_PUBLIC_REPOSITORY',defaultValue:'public.ecr.aws/has',description:'The ECR Public repo')
    }
    
    environment {
        AWS_REGION             = 'us-east-1'
        DOCKER_DB_IMAGE_NAME   = 'cicd_db_image' 
        DOCKER_WS_IMAGE_NAME   = 'cicd_frontend_image'
        DOCKER_IMAGE_TAG       = 'latest' 
        MYSQL_HOST             = ''
    }
    
    stages {
        stage('Build Db') {
            steps {
                 sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_PUBLIC_REPOSITORY}"
                 sh "docker compose -f docker-compose-build.yaml build db_app"
                 sh "docker compose -f docker-compose-build.yaml push db_app"
            }
        }
        stage('Deploy DB') {
            steps {
                sh "docker compose run mysql_deploy"
            }
        }
        stage('Get DB ip') {
            steps {
                script {
                    sh 'sleep 60'
                    sh 'aws ecs list-tasks --region us-east-1 --cluster my_test_ecs > output.json'
                    sh 'aws ecs describe-tasks --region us-east-1 --cluster my_test_ecs --task $(cat output.json | jq -r .taskArns[0]) > output.json'
                    sh 'cat output.json | jq -r .tasks[0].attachments[0].details[-1].value > dbPrivateIp.txt'
                    sh 'rm output.json'
                }
            }
        }
        stage('Build frontend') {
            steps {
                script {
                    def container_ip = sh(returnStdout: true, script: "cat dbPrivateIp.txt").trim()
                    withEnv(["MYSQL_HOST=${container_ip}"]) {
                        sh 'docker compose -f docker-compose-build.yaml build webserver_app'
                        sh 'docker compose -f docker-compose-build.yaml push webserver_app'
                        sh 'rm dbPrivateIp.txt'
                    }
                }
            }
        }
        stage('Deploy frontend') {
            steps {
                sh 'docker compose run webserver_deploy'
            }
        }
    }
}
