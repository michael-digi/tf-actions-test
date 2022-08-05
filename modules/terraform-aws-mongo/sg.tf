resource "aws_security_group" "vpc_access" {
  name   = "vpc-access-sg-${var.env}-${var.region}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
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

resource "aws_security_group" "mongo" {
  name   = "mongo-sg-${var.env}-${var.region}"
  vpc_id = var.vpc_id
  
  description = "Access between Mongo nodes."
  
  tags = {
    Name = "${var.env}_mongo_access"
  }
}

resource "aws_security_group_rule" "mongo_ingress" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 27017
  to_port           = 27017
  security_group_id = aws_security_group.mongo.id
  source_security_group_id = aws_security_group.mongo.id
}

resource "aws_security_group_rule" "mongo_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.mongo.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group" "efs" {
  name   = "efs-sg-${var.env}-${var.region}"
  vpc_id = var.vpc_id
  
  description = "Access between Mongo nodes."
  
  tags = {
    Name = "${var.env}_efs_access"
  }
}

resource "aws_security_group_rule" "efs_ingress_tcp" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  security_group_id = aws_security_group.efs.id
  source_security_group_id = aws_security_group.mongo.id
}

resource "aws_security_group_rule" "efs_ingress_icmp" {
  type              = "ingress"
  protocol          = "icmp"
  from_port         = 8
  to_port           = 0
  security_group_id = aws_security_group.mongo.id
  source_security_group_id = aws_security_group.mongo.id
}

resource "aws_security_group_rule" "efs_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.efs.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}