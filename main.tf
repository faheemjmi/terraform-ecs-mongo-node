# Terraform Block
terraform {
  required_version = "~> 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-state-noi"
    key    = "dev/terraform.tfstate"
    region = "us-east-1" 

    # Enable during Step-09     
    # For State Locking
    #dynamodb_table = "nexus-sandbox-state"    
  } 
}

provider "aws" {
  region = "${var.aws_region}"
}

module "iam" {
  source = "./terraform-manifests/iam"
}

module "vpc" {
  source = "./terraform-manifests/vpc"
  vpc_name = "${var.app_name}-${var.app_env}" 
  vpc_cidr_block = var.vpc_cidr_block
  vpc_availability_zones = var.vpc_availability_zones
  vpc_public_subnets = var.vpc_public_subnets
  vpc_private_subnets = var.vpc_private_subnets
  vpc_database_subnets= var.vpc_database_subnets
  vpc_create_database_subnet_group = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table   
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway  
  vpc_single_nat_gateway = var.vpc_single_nat_gateway
}

module "security_groups" {
  source = "./terraform-manifests/security_groups"
  app_name = var.app_name
  app_env  = var.app_env  
  vpc_id = "${module.vpc.vpc_id}"
  pb_cidr_block = var.pb_cidr_block
  vpc_cidr_block = var.vpc_cidr_block
}

# Backend Service Deployment

module "backend_load_balancers" {
  source = "./terraform-manifests/load_balancers"
  alb_name = "${var.app_name}-${var.app_env}-backend"
  public_subnet_id = "${module.vpc.public_subnets}"
  alb_sg_id = "${module.security_groups.alb_sg_id}"
  vpc_id = "${module.vpc.vpc_id}"
  healthcheck_path = "/goals"
}

module "ecs_backend" {
  source = "./terraform-manifests/ecs"
  app_name = var.app_name
  app_env  = var.app_env
  app_type = "backend"
  ecs_role_arn = "${module.iam.ecs_role_arn}"
  alb_sg_id = "${module.security_groups.alb_sg_id}"
  public_subnet_id = "${module.vpc.public_subnets}"
  target_group_arns = "${module.backend_load_balancers.target_group_arns}"
  image_name = "${var.backend_image}:${var.image_version}"
  env_variables = [{"name": "MONGODB_URL", "value": "${var.MONGODB_URL}"},
                    {"name": "MONGODB_NAME", "value": "${var.MONGODB_NAME}"},
                    {"name": "MONGODB_USERNAME", "value": "${var.MONGODB_USERNAME}"},
                    {"name": "MONGODB_PASSWORD", "value": "${var.MONGODB_PASSWORD}"}
                  ]
}

module "backend_route53" {
  source = "./terraform-manifests/route_53"
  domain_name = var.domain_name
  app_name = "backend" #var.app_name
  lb_dns_name = "${module.backend_load_balancers.lb_dns_name}"
  lb_zone_id = "${module.backend_load_balancers.lb_zone_id}"
}

##End Backend Service

#####FrontEnd Service Deployment

  module "frontend_load_balancers" {
    source = "./terraform-manifests/load_balancers"
    alb_name = "${var.app_name}-${var.app_env}-frontend"
    public_subnet_id = "${module.vpc.public_subnets}"
    alb_sg_id = "${module.security_groups.alb_sg_id}"
    vpc_id = "${module.vpc.vpc_id}"
  }

  module "ecs_frontend" {
  source = "./terraform-manifests/ecs"
  app_name = var.app_name
  app_env  = var.app_env
  app_type = "frontend"
  ecs_role_arn = "${module.iam.ecs_role_arn}"  
  alb_sg_id = "${module.security_groups.alb_sg_id}"
  public_subnet_id = "${module.vpc.public_subnets}"
  target_group_arns = "${module.frontend_load_balancers.target_group_arns}"
  image_name = "${var.frontend_image}:${var.image_version}"
}

module "frontend_route53" {
  source = "./terraform-manifests/route_53"
  domain_name = var.domain_name
  app_name = "demo"
  lb_dns_name = "${module.frontend_load_balancers.lb_dns_name}"
  lb_zone_id = "${module.frontend_load_balancers.lb_zone_id}"
}
