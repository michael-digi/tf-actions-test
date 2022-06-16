terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "michael-digi"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "tf-actions-test-2"
    }
  }
}

provider "aws" {
  region = var.region
}

# data "aws_acm_certificate" "test_com" {
#   domain = "www.michaelpdigiorgio.com"
# }

locals {
  vpc_cidr = var.environment == "production" ? "172.16.0.0/16" : (var.environment == "staging" ? "10.0.0.0/16" : "192.168.0.0/16")
}

locals {
  subnets = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet("10.0.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet("10.0.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
}

module "networking" {
  source   = "../../terraform-aws-networking"
  vpc_name = "New"

  public_private_subnet_pairs = local.subnets
  vpc_primary_cidr            = local.vpc_cidr // will be determined by dev/staging/prod vars
}

module "ecs" {
  source          = "../../terraform-aws-ecs"
  private_subnets = module.networking.private_subnets

  vpc_id = module.networking.vpc_id
}