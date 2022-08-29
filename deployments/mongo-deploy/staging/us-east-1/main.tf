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

locals {
  private_subnet_ids = {
    value = [for s in data.aws_subnet.private : s.id]
  }
}

module "mongo_cluster_1" {
  source = "../../../../modules/terraform-aws-mongo"
  private_subnets = local.private_subnet_ids.value
  image = "${var.ecr_repo_admin_account}.dkr.ecr.${var.ecr_repo_admin_region}.amazonaws.com/mongo_cluster_${var.env}:latest"
  env = var.env
  region = var.region
  vpc_id = data.aws_vpc.vpc.id
  account_id = var.account_id
  mongo_node_count = var.mongo_node_count
}
