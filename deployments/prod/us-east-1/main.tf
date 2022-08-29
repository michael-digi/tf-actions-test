terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

locals {
  subnet_pairs = {
    production = flatten([
      {
        az          = "${var.region}a"
        cidr        = "172.16.64.0/20"
        public_cidr = "172.16.0.0/20"
      },
      {
        az          = "${var.region}b"
        cidr        = "172.16.80.0/20"
        public_cidr = "172.16.16.0/20"
      },
      {
        az          = "${var.region}c"
        cidr        = "172.16.96.0/20"
        public_cidr = "172.16.32.0/20"
      },
      var.subnets == 4 ? [{
        az          = "${var.region}d"
        cidr        = "172.16.112.0/20"
        public_cidr = "172.16.48.0/20"
      }] : []
    ])
  }
}

module "networking" {
  source   = "../../../modules/terraform-aws-networking"
  vpc_name = "${var.env}-${var.region}-vpc"
  env = var.env
  region = var.region
  public_private_subnet_pairs = local.subnet_pairs[var.env]
  vpc_primary_cidr            = var.vpc_cidr[var.env]
}

module "mongo" {
  source = "../../../modules/terraform-aws-mongo"
  private_subnets = local.private_subnet_ids.value
  image = "${var.ecr_repo_admin_account}.dkr.ecr.${var.ecr_repo_admin_region}.amazonaws.com/mongo_cluster_${var.env}:latest"
  env = var.env
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
  account_id = var.account_id
  mongo_node_count = var.mongo_node_count
}

module "ecs" {
  source = "../../../modules/terraform-aws-ecs"
  private_subnets = local.private_subnet_cidr_blocks.value
  public_subnets  = local.public_subnet_cidr_blocks.value
  num_containers = var.num_containers
  image = "${var.ecr_repo_admin_account}.dkr.ecr.${var.ecr_repo_admin_region}.amazonaws.com/gck_portal_${var.env}:latest"
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
  env = var.env
}
