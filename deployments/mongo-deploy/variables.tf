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
  type = string
  default = ""
}

variable "ecr_repo_admin_account" {
  type = string
  default = "314694303532"
}

variable "ecr_repo_admin_region" {
  type = string
  default = "us-east-1"
}

variable "image" {
  type = string
  default = ""
}

variable "mongo_node_count" {
  default = 3
}
