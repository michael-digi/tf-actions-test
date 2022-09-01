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

locals {
  subnet_pairs = {
    dev = flatten([
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
  }
}

module "networking" {
  source   = "../../../../modules/terraform-aws-networking"
  vpc_name = "${var.env}-${var.region}-vpc"
  env = var.env
  region = var.region
  public_private_subnet_pairs = local.subnet_pairs[var.env]
  vpc_primary_cidr            = var.vpc_cidr[var.env]
}