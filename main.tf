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

data "custom_resource" "yah" {
  count = var.subnets

  public_private_subnet_pairs = [{
    az          = join("", ["${var.region}, ${var.availability_zone_postfix[count.index]}"])
    cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, count.index)
    public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, count.index)
  }]
}

module "networking" {
  source = "./terraform-aws-networking"

  public_private_subnet_pairs = data.custom_resource_yah.*.rendered
  vpc_primary_cidr            = "172.16.0.0/16"
}