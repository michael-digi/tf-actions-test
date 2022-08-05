variable "mongo_image" {
  default = "image"
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "production"
}

variable "account_id" {
  default = ""
}

variable "private_subnets" {}
variable "vpc_id" {}