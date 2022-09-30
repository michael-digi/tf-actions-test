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
    staging = flatten([
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
}

module "networking" {
  source   = "../../../../modules/terraform-aws-networking"
  vpc_name = "${var.env}-${var.region}-vpc"
  env = var.env
  region = var.region
  public_private_subnet_pairs = local.subnet_pairs[var.env]
  vpc_primary_cidr            = var.vpc_cidr[var.env]
}