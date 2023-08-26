variable "VPC_ID" {}

variable "ECS_NAME" {}

variable "ECR_URL" {}


module "deploy_server"  {
    source = "github.com/jonspandorf/terraform_modules//ecs_task_def"
    vpc_id = var.VPC_ID
    requested_ecs = var.ECS_NAME
    ecr_image_url = var.ECR_URL
    container_name = "frontend_container"
    ecs_task_port = 80
    public_endpoint_ports = [80,80]
    task_role_name = "MySpecialFrontendRole"
    service_name = "frontend-service"
    service_container_count = 2
    loadbalancer_name = "my-cool-lb"
}

