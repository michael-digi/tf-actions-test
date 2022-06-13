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

data "aws_acm_certificate" "test_com" {
  domain = "michaelpdigiorgio.com"
}

locals {
  subnets = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
}

# module "networking" {
#   source = "./terraform-aws-networking"

#   public_private_subnet_pairs = local.subnets
#   vpc_primary_cidr            = "172.16.0.0/16" // will be determined by dev/staging/prod vars
# }

module "ecr_repo" {
  source = "./terraform-aws-ecr"

  repository_list   = ["gck-portal"]
  pull_account_list = [417363389520]
}