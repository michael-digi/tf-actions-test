variable "vpc_cidr" { default = "172.16.0.0/16" }
variable "vpc_subnet_bits" { default = 2 }
variable "vpc_zone_count" { default = 4 }
variable "vpc_zone_bits" { default = 2 }
variable "vpc_subnet_indices" {
  type = map(string)
  default = {
    "public"  = 0
    "private" = 1
  }
}

variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-east-1"
}