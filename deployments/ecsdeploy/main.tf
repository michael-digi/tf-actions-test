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
    organization = "michael-digi" // temp, testing

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "tf-actions-test-2" // temp, testing
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
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

data "aws_subnets" "public" {
  filter {
    name   = "tag:Tier"
    values = ["Public Subnets"]
  }

  filter {
    name   = "tag:Vpc"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  public_subnet_cidr_blocks = {
    value = [for s in data.aws_subnet.public : s.id]
  }

  private_subnet_cidr_blocks = {
    value = [for s in data.aws_subnet.private : s.id]
  }
}

output "hey" {
  value = data.aws_vpc.vpc.id
}

module "ecs" {
  source = "../../terraform-aws-ecs"

  private_subnets = local.private_subnet_cidr_blocks.value
  public_subnets  = local.public_subnet_cidr_blocks.value

  vpc_id = data.aws_vpc.vpc.id
}
