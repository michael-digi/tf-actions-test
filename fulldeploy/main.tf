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
  staging_subnets = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet("10.0.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet("10.0.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
  prod_subnets = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet("172.16.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet("172.16.0.0/16", var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
}

module "networking" {
  source      = "./terraform-aws-networking"
  vpc_name    = "S"
  environment = var.environment

  public_private_subnet_pairs = local.staging_subnets
  vpc_primary_cidr            = "10.0.0.0/16" // will be determined by dev/staging/prod vars
}

module "networking" {
  source      = "./terraform-aws-networking"
  vpc_name    = "P"
  environment = var.environment

  public_private_subnet_pairs = local.prod_subnets
  vpc_primary_cidr            = "172.16.0.0/16" // will be determined by dev/staging/prod vars
}

module "ecr_repo" {
  source = "./terraform-aws-ecr"

  repository_list   = ["gck-portal"]
  pull_account_list = [417363389520]
}