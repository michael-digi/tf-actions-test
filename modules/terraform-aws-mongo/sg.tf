resource "aws_security_group" "mongo" {
  name   = "mongo-sg-${var.env}-${var.region}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 27017
    to_port          = 27017
    cidr_blocks      = ["192.168.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}