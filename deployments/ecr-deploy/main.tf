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

module "ecr_repo" {
  source = "../../terraform-aws-ecr"

  repository_list   = ["gck_portal_prod", "gck_portal_staging", "gck_portal_dev"]
  pull_account_list = [417363389520]
}