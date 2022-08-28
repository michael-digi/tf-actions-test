resource "aws_route53_zone" "private" {
  name = "gocheck-${var.env}-${var.region}.com"

  vpc {
    vpc_id = var.vpc_id
  }
}