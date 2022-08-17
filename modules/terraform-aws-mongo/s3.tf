resource "aws_kms_key" "mongo_backups_key" {
  description             = "This key is used to encrypt the mongo backups bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mongo_backups" {
  bucket = "mongo-backups-${var.account_id}-${var.env}-${var.region}"

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "mongo_backups_lock_configuration" {
  bucket = aws_s3_bucket.mongo_backups.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      years = 1
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mongo_backups" {
  bucket = aws_s3_bucket.mongo_backups.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mongo_backups_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.mongo_backups.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}