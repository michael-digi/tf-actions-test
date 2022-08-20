variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "app_name" {
  description = "Name of portal app"
  type        = string
  default     = "gck-portal"
}

variable "account_id_prod" {
  type        = string
  default     = "152823419987"
}

variable "account_id_staging" {
  type        = string
  default     = "952899752506"
}

variable "account_id_dev" {
  type        = string
  default     = "946265355097"
}