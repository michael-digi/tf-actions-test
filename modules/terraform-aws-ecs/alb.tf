# resource "aws_lb" "gck_portal" {
#   name               = "${var.app_name}-alb-${var.env}"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups = [
#     aws_security_group.alb.id
#   ]
  
#   subnets = var.public_subnets
#   enable_deletion_protection = false
# }

# resource "aws_alb_target_group" "gck_portal" {
#   name        = "${var.app_name}-tg-${var.env}"
#   port        = 443
#   protocol    = "HTTPS"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "4"
#     interval            = "30"
#     protocol            = "HTTPS"
#     matcher             = "200"
#     timeout             = "3"
#     path                = "/login/auth"
#     unhealthy_threshold = "2"
#   }
# }

# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_lb.gck_portal.id
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.gck_portal.id
#     type             = "forward"
#   }
# }

# resource "aws_alb_listener" "https" {
#   load_balancer_arn = aws_lb.gck_portal.id
#   port              = 443
#   protocol          = "HTTPS"

#   ssl_policy      = "ELBSecurityPolicy-2016-08"
#   certificate_arn = var.alb_tls_cert_arn

#   default_action {
#     target_group_arn = aws_alb_target_group.gck_portal.id
#     type             = "forward"
#   }
# }