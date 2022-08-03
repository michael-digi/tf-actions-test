resource "aws_s3_bucket" "terraform-state" {
 bucket = "${var.account_id}-${var.env}-terraform-state"
 acl    = "private"

 versioning {
   enabled = true
 }
}

 resource "aws_dynamodb_table" "terraform-state" {
 name           = "terraform-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }

#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        kms_master_key_id = var.kms_arn
#        sse_algorithm     = "aws:kms"
#      }
#    }
#  }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}