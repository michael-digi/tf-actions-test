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
    values = ["primary_${var.env}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = ["Private Subnets"]
  }

  filter {
    name   = "tag:Vpc"
    values = ["primary_${var.env}"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

locals {
  private_subnet_ids = {
    value = [for s in data.aws_subnet.private : s.id]
  }
}

module "mongo" {
  source = "../../module/terraform-aws-mongo"
  private_subnets = local.private_subnet_ids.value
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
}
