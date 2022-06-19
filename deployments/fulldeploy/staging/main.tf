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
    organization = "michael-digi" // temporary, testing

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "tf-actions-test-2" // temporary, testing
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  subnet_pairs_staging = flatten([
    {
      az          = "${var.region}a"
      cidr        = "10.0.64.0/20"
      public_cidr = "10.0.0.0/20"
    },
    {
      az          = "${var.region}b"
      cidr        = "10.0.80.0/20"
      public_cidr = "10.0.16.0/20"
    },
    {
      az          = "${var.region}c"
      cidr        = "10.0.96.0/20"
      public_cidr = "10.0.32.0/20"
    },
    var.subnets == 4 ? [{
      az          = "${var.region}d"
      cidr        = "10.0.112.0/20"
      public_cidr = "10.0.48.0/20"
    }] : []
  ])

  subnet_pairs_dev = flatten([
    {
      az          = "${var.region}a"
      cidr        = "192.168.64.0/20"
      public_cidr = "192.168.0.0/20"
    },
    {
      az          = "${var.region}b"
      cidr        = "192.168.80.0/20"
      public_cidr = "192.168.16.0/20"
    },
    {
      az          = "${var.region}c"
      cidr        = "192.168.96.0/20"
      public_cidr = "192.168.32.0/20"
    },
    var.subnets == 4 ? [{
      az          = "${var.region}d"
      cidr        = "192.168.112.0/20"
      public_cidr = "192.168.48.0/20"
    }] : []
  ])
}

module "networking_staging" {
  source   = "../../../terraform-aws-networking"
  vpc_name = "New_staging"

  public_private_subnet_pairs = local.subnet_pairs_staging
  vpc_primary_cidr            = var.vpc_cidr_staging // will be determined by dev/staging/prod vars
}

module "networking_dev" {
  source   = "../../../terraform-aws-networking"
  vpc_name = "New_dev"

  public_private_subnet_pairs = local.subnet_pairs_dev
  vpc_primary_cidr            = var.vpc_cidr_dev // will be determined by dev/staging/prod vars
}

module "ecs_staging" {
  source          = "../../../terraform-aws-ecs"
  private_subnets = module.networking_staging.private_subnets

  vpc_id = module.networking_staging.vpc_id
}

module "ecs_dev" {
  source          = "../../../terraform-aws-ecs"
  private_subnets = module.networking_dev.private_subnets

  vpc_id = module.networking_dev.vpc_id
}
