variable "mongo_image" {
  default = "image"
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "staging"
}

variable "account_id" {
  default = ""
}

variable "image" {
  default = ""
}

variable "mongo_node_count" {
  default = 3
}

variable "private_subnets" {}

variable "vpc_id" {}

