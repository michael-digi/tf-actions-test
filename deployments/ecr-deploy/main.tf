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

  repository_list   = [
    "gck_portal_prod", 
    "gck_portal_staging", 
    "gck_portal_dev",
    "mongo_cluster_prod",
    "mongo_cluster_staging",
    "mongo_cluster_dev",
  ]
  
  pull_account_list = [
    var.account_id_prod,
    var.account_id_staging,
    var.account_id_dev,
  ]

  push_account_list = [
    var.account_id_prod,
    var.account_id_staging,
    var.account_id_dev,
  ]
}