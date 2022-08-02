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

module "ecr_repo" {
  source = "../../modules/terraform-aws-ecr"

  repository_list   = ["gck_portal_prod", "gck_portal_staging", "gck_portal_dev"]
  pull_account_list = [417363389520]
}