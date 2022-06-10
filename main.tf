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

module "networking" {
  source = "./terraform-aws-networking"

  public_private_subnet_pairs = {
    az          = "${var.region}a"
    cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, count.index)
    public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, count.index)
  }
  vpc_primary_cidr = "172.16.0.0/16"
}