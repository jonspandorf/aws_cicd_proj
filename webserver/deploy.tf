variable "VPC_ID" {}

variable "ECS_NAME" {}


module "deploy_server"  {
    source = "github.com/jonspandorf/terraform_modules//ecs_task_def"
    vpc_id = var.VPC_ID
    requested_ecs = var.ECS_NAME
    ecr_image_url = "public.ecr.aws/l5l8z6i3/panaya_webserver"
    container_name = "panaya_webserver"
    ecs_task_port = 80
    public_endpoint_ports = [9080,9080]
    task_role_name = "PanayaServerTask"
    service_name = "panaya-service"
    service_container_count = 2
    loadbalancer_name = "panaya-lb"
}

