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

# resource "aws_dynamodb_table" "terraform-state" {
#  name           = "terraform-state"
#  read_capacity  = 20
#  write_capacity = 20
#  hash_key       = "LockID"

#  attribute {
#    name = "LockID"
#    type = "S"
#  }
# }

# resource "aws_kms_key" "terraform-bucket-key" {
#  description             = "This key is used to encrypt bucket objects"
#  deletion_window_in_days = 10
#  enable_key_rotation     = true
# }

# resource "aws_kms_alias" "key-alias" {
#  name          = "alias/terraform-bucket-key"
#  target_key_id = aws_kms_key.terraform-bucket-key.key_id
# }

module "remote_backend_s3" {
  source = "../../module/terraform-aws-backend-s3"
  env = var.env
  region = var.region
  account_id = var.account_id
}
