variable "vpc_name" {
  default     = "7Factor Test VPC"
  description = "Name of the VPC. Shows up in tags. Defaults to 'Primary VPC'"
}

# This will actually be a list of maps, which stores information about
# the public/private subnet configuration. Every private subnet needs
# a corresponding public subnet. This is especially usefull if you're
# going to load balance something inside a private subnet.
variable "public_private_subnet_pairs" {
  type        = list(any)
  description = "A list of maps that connect public and private subnet pairs."
}

# At least one CIDR Needs to exist on the VPC in order to create it. All other values will be inferred when you
# create your subnets. Magic!
variable "vpc_primary_cidr" {
  description = "To avoid any irritation with specifying CIDRs that belong on a VPC specify one that's your primary."
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Enabling this is required for using private hosted zones in Route 53."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Enabling this is required for using private hosted zones in Route 53."
  type        = bool
  default     = true
}

variable "env" {
  description = "Which environment we're deploying into"
  type        = string
  default     = "dev"
}