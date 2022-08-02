resource "aws_ecs_cluster" "gck_portal" {
  name = "${var.app_name}-cluster-${var.env}"
}