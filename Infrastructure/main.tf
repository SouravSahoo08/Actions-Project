terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "actions-tf-state-bucket"
    key = "ecs-project/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "iam" {
  source = "./modules/iam"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.vpc.vpc_id
  alb_sg = [module.alb.alb_sg]
  cpu = var.ecs_cpu
  memory = var.ecs_memory
  iam_task_execution_role = module.iam.ecs_task_execution_role_arn
  image = var.image # to be changed
  container_port = var.container_port  # to be changed
  private_subnets = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.alb_target_group_arn
}
