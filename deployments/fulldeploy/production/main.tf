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

# locals {
#   subnets = [
#     for index, az in slice(var.availability_zone_postfix, 0, var.subnets) : {
#       az          = join("", ["${var.region}", "${az}"])
#       cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, index)
#       public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, index)
#   }]
# }

module "networking" {
  source   = "../../../terraform-aws-networking"
  vpc_name = "New"

  public_private_subnet_pairs = local.subnet_pairs
  vpc_primary_cidr            = var.vpc_cidr // will be determined by dev/staging/prod vars
}

module "ecs" {
  source          = "../../../terraform-aws-ecs"
  private_subnets = module.networking.private_subnets

  vpc_id = module.networking.vpc_id
}
