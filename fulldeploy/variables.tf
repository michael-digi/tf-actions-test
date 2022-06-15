variable "vpc_cidr" { default = "172.16.0.0/16" }
variable "vpc_subnet_bits" { default = 4 }
variable "vpc_zone_bits" { default = 2 }
variable "vpc_subnet_indices" {
  type = map(string)
  default = {
    "public"  = 0
    "private" = 1
  }
}

variable "availability_zone_postfix" {
  description = "Region postfix"
  type        = list(any)
  default     = ["a", "b", "c", "d"]
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

variable "environment" {
  description = "Environment deploying to"
  type        = string
  default     = "dev"
}