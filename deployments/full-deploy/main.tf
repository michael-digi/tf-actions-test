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
  subnet_pairs = flatten([
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

module "networking" {
  source = "../../../terraform-aws-networking"
  env    = var.env
  region = var.region

  public_private_subnet_pairs = local.subnet_pairs
  vpc_primary_cidr            = var.vpc_cidr
}

module "ecs" {
  source = "../../../terraform-aws-ecs"

  private_subnets = module.networking.private_subnets
  public_subnets  = module.networking.public_subnets

  num_containers = var.num_containers
  region = var.region
  env = var.env

  vpc_id = module.networking.vpc_id
}
