resource "aws_s3_bucket" "terraform-state" {
 bucket = "${var.env}-miked-${var.region}"
 acl    = "private"

 versioning {
   enabled = true
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