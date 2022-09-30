terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["primary-${var.env}-${var.region}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = ["Private Subnets"]
  }

  filter {
    name   = "tag:Vpc"
    values = ["primary-${var.env}-${var.region}"]
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
    values = ["primary-${var.env}-${var.region}"]
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

module "ecs" {
  source = "../../../../modules/terraform-aws-ecs"
  private_subnets = local.private_subnet_cidr_blocks.value
  public_subnets  = local.public_subnet_cidr_blocks.value
  num_containers = var.num_containers
  image = "${var.account_id_admin}.dkr.ecr.${var.ecr_repo_admin_region}.amazonaws.com/gck_portal_${var.env}:latest"
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
  env = var.env
}
