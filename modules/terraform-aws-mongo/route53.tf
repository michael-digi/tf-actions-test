resource "aws_route53_zone" "private" {
  name = "miked-${var.env}.com"

  vpc {
    vpc_id = var.vpc_id
  }
}