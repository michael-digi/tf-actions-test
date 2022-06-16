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
  subnets_staging = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr_staging, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr_staging, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
  subnets_dev = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr_dev, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr_dev, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
}

module "networking_staging" {
  source   = "../../../terraform-aws-networking"
  vpc_name = "New"

  public_private_subnet_pairs = local.subnets_staging
  vpc_primary_cidr            = local.vpc_cidr_staging // will be determined by dev/staging/prod vars
}

module "networking_dev" {
  source   = "../../../terraform-aws-networking"
  vpc_name = "New"

  public_private_subnet_pairs = local.subnets_dev
  vpc_primary_cidr            = local.vpc_cidr_dev // will be determined by dev/staging/prod vars
}

module "ecs_staging" {
  source          = "../../../terraform-aws-ecs"
  private_subnets = module.networking_staging.private_subnets

  vpc_id = module.networking_staging.vpc_id
}

module "ecs_dev" {
  source          = "../../../terraform-aws-ecs"
  private_subnets = module.networking_dev.private_subnets

  vpc_id = module.networking_dev.vpc_id
}
