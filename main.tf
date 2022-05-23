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
  region = "us-east-2"
}

module "networking" {
  source = "./terraform-aws-networking"

  public_private_subnet_pairs = [
    {
      az          = "us-east-2a"
      cidr        = "176.16.64.0/20"
      public_cidr = "176.16.0.0/20"
    },
    {
      az          = "us-east-2b"
      cidr        = "176.16.80.0/20"
      public_cidr = "176.16.16.0/20"
    },
    {
      az          = "us-east-2c"
      cidr        = "176.16.96.0/20"
      public_cidr = "176.16.32.0/20"
    },
    # {
    #   az          = "us-east-1d"
    #   cidr        = "176.16.112.0/20"
    #   public_cidr = "176.16.48.0/20"
    # },
  ]
  vpc_primary_cidr = "176.16.0.0/16"
}