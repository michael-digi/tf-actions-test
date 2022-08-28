variable "vpc_cidr" {
  default = {
    production = "172.16.0.0/16",
    staging = "192.168.0.0/16",
    dev = "10.0.0.0/16"
  } 
}

variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "subnets" {
  description = "Number of subnets"
  type        = number
  default     = 3
}

variable "env" {
  description = "Environment deploying to"
  type        = string
  default     = "dev"
}