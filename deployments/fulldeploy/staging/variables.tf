variable "vpc_cidr" { default = "172.16.0.0/16" }
variable "vpc_cidr_staging" { default = "10.0.0.0/16" }
variable "vpc_cidr_dev" { default = "192.168.0.0/16" }

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

variable "num_containers" {
  description = "The number of Fargate containers to spin up in the ECS cluster"
  type        = number
  default     = 2
}