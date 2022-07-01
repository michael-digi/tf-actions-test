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
      prefix = "production-"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = ["Private Subnets"]
  }

  filter {
    name   = "tag:Vpc"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

locals {
  private_subnet_cidr_blocks = {
    value = [for s in data.aws_subnet.private : s.id]
  }
}

module "mongo" {
  source = "../../../terraform-aws-mongo"
  private_subnets = local.private_subnet_cidr_blocks.value
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
}
