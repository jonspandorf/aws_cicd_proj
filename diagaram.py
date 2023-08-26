from diagrams import Diagram, Cluster
from diagrams.aws.compute import ECS, EC2, ECR
from diagrams.aws.network import ALB, VPC
from diagrams.onprem.container import Docker
from diagrams.onprem.iac import Terraform
from diagrams.onprem.ci import Jenkins


with Diagram("App Infrastructure", show=False):
    with Cluster("VPC Network"):
        jenkins = Jenkins("Jenkins")
        ecs_cluster = ECS("ECS Cluster")
        docker = Docker("Docker")
        terraform = Terraform("Terraform")

    ecr = ECR("ECR")

    alb = ALB("ALB")

    jenkins >> docker >> ecr 
    ecr >> ecs_cluster
    jenkins >> docker >> terraform >> ecs_cluster
    alb >> ecs_cluster
