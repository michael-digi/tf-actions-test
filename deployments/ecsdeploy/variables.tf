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

variable "num_containers" {
  description = "The number of Fargate containers to spin up in the ECS cluster"
  type        = number
  default     = 2
}
