variable "vpc_cidr" { default = "172.16.0.0/16" }

variable "image_version" { default = "latest" }

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

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(any)
  default     = []
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(any)
  default     = []
}

variable "vpc_id" {
  description = "ID of VPC"
  type        = string
  default     = ""
}

variable "app_name" {
  description = "Name of GoCheck portal app"
  type        = string
  default     = "gck-portal"
}

variable "num_containers" {
  description = "The number of Fargate containers to spin up in the ECS cluster"
  type        = number
  default     = 1
}

variable "alb_tls_cert_arn" {
  default = ""
}

variable "image" {
  default = ""
}