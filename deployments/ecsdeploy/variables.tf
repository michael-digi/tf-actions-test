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

variable "vpc_id" {}