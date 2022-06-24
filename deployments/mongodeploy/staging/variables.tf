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

variable "aws_ami" {
  default = "amzn2-ami-ecs-hvm-2.0.20220607-x86_64-ebs"
}

variable "instance_type" {
  default = "t2.micro"
}