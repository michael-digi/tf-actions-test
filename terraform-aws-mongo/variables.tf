variable "mongo_image" {
  default = "image"
}

variable "region" {
    default = "us-east-1"
}

variable "env" {
    default = "production"
}

variable "private_subnets" {}
variable "vpc_id" {}
variable "private_subnet_ids" {}