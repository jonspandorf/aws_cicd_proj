variable "VPC_ID" {}

variable "ECS_NAME" {}

variable "MYSQL_DATABASE" {}

variable "MYSQL_ROOT_PASSWORD" {}

module "deploy_db" {
    source = "github.com/jonspandorf/terraform_modules//ecs_task_def"
    is_public_deployment = false
    vpc_id = "${var.VPC_ID}"
    requested_ecs = "${var.ECS_NAME}"
    ecr_image_url = "public.ecr.aws/l5l8z6i3/panayadb"
    container_name = "panaya_db"
    ecs_task_port = 3306
    container_port = 3306
    task_role_name = "PanayaDBTask"
    task_cpu     = 512
    task_ram      = 1024
    container_cpu = 512
    container_ram = 1024
    service_name = "panayadb-service"
    service_container_count = 1
    requested_security_group_id = "sg-0dc4346f88aa67d40"
    container_env = [
                        {
                            "name": "MYSQL_DATABASE",
                            "value": "${var.MYSQL_DATABASE}"
                        },
                        {
                            "name": "MYSQL_ROOT_PASSWORD",
                            "value": "${var.MYSQL_ROOT_PASSWORD}"
                        }
                    ]
}