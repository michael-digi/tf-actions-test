variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "env" {
  description = "Environment deploying to"
  type        = string
  default     = "dev"
}

variable "account_id" {
  description = "Account bucket is in"
  type        = string
  default     = ""
}

# variable "kms_arn" {
#   description = "Arn of KMS key for S3 bucket"
#   type        = string
#   default     = ""
# }
