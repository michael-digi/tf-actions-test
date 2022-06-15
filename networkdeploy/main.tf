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

locals {
  subnets = [
    for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
      az          = join("", ["${var.region}", "${az}"])
      cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
      public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
  }]
  vpc_cidr = var.environment == "production" ? "172.16.0.0/16" : (var.environment == "staging" ? "10.0.0.0/16" : "")
}

module "networking" {
  source = "./terraform-aws-networking"

  public_private_subnet_pairs = local.subnets
  vpc_primary_cidr            = local.vpc_cidr
}