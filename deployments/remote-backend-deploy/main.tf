terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}


module "remote_backend_s3" {
  source = "../../terraform-aws-backend-s3"
  region = var.region
}
