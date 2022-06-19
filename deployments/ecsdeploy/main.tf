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

data "aws_vpc" "primary_vpc" {
  filter {
    name   = "Name"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "Tier"
    values = ["Private Subnets"]
  }

  filter {
    name   = "Vpc"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

var "private_subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.private : s.cidr_block]
}

data "aws_subnets" "public" {
  filter {
    name   = "Tier"
    values = ["Public Subnets"]
  }

  filter {
    name   = "Vpc"
    values = ["Primary_${var.env}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

var "public_subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.private : s.cidr_block]
}

module "ecs" {
  source          = "../../../terraform-aws-ecs"
  
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  
  vpc_id = data.aws_vpc.primary_vpc.id
}
