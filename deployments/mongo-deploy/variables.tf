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

variable "image" {
  type = string
  default = ""
}

variable "mongo_node_count" {
  default = 3
}