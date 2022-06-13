resource "aws_lb" "gck_portal" {
  name               = "gck-portal-alb-prod"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb.id
  ]
  subnets = module.terraform-aws-networking.private_subnets

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "gck_portal" {
  name        = "gck-portal-tg-prod"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.terraform-aws-networking.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/ping"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.gck_portal.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.gck_portal.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.test_com

  default_action {
    target_group_arn = aws_alb_target_group.gck_portal.id
    type             = "forward"
  }
}