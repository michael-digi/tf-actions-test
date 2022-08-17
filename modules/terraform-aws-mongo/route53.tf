resource "aws_route53_zone" "private" {
  name = "miked-${var.env}.com"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "mongo_node_dns" {
  count = 3
  zone_id = aws_route53_zone.private.zone_id
  name    = "mongo0${count.index + 1}.miked.com"
  type    = "A"
  ttl     = 0
}