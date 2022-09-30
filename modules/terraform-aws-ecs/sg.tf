resource "aws_security_group" "alb" {
  name   = "${var.app_name}-sg-alb-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
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

resource "aws_security_group" "from_alb" {
  name   = "from-alb-sg-${var.env}-${var.region}"
  vpc_id = var.vpc_id
  
  description = "Allows SG to access resources."
  
  tags = {
    Name = "${var.env}_from_alb_access"
    Env = "${var.env}"
    Region = "${var.region}"
  }
}

resource "aws_security_group_rule" "from_alb_ingress_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  security_group_id = aws_security_group.from_alb.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "from_alb_ingress_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.from_alb.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "from_alb_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.from_alb.id
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

