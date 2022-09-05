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

variable "account_id_admin" {
  type = string
  default = "417363389520"
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
