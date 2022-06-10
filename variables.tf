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


variable "public_private_subnet_pairs" {
    default = [{
      az          = "${var.region}a"
      cidr        = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "private")), var.vpc_zone_bits, count.index)
      public_cidr = cidrsubnet(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, lookup(var.vpc_subnet_indices, "public")), var.vpc_zone_bits, count.index)
    }]
    # {
    #   az          = "${var.region}b"
    #   cidr        = "176.16.80.0/20"
    #   public_cidr = "176.16.16.0/20"
    # },
    # {
    #   az          = "${var.region}c"
    #   cidr        = "176.16.96.0/20"
    #   public_cidr = "176.16.32.0/20"
    # },
    # {
    #   az          = "${var.region}d"
    #   cidr        = "176.16.112.0/20"
    #   public_cidr = "176.16.48.0/20"
    # },
    # {
    #   az          = "${var.region}e"
    #   cidr        = "176.16.128.0/20"
    #   public_cidr = "176.16.54.0/20"
    # },
    # {
    #   az          = "${var.region}f"
    #   cidr        = "176.16.144.0/20"
    #   public_cidr = "176.16.70.0/20"
    # }]
}