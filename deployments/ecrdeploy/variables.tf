variable "availability_zone_postfix" {
  description = "Region postfix"
  type        = list(any)
  default     = ["a", "b", "c", "d", "e", "f"]
}

variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-west-2"
}
