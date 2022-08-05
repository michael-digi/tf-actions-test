resource "aws_ecs_service" "gck_portal" {
  name                               = "${var.app_name}-service-${var.env}"
  cluster                            = aws_ecs_cluster.gck_portal.id
  task_definition                    = aws_ecs_task_definition.gck_portal.arn
  desired_count                      = var.num_containers
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  # load_balancer {
  #   target_group_arn = aws_alb_target_group.gck_portal.arn
  #   container_name   = "${var.app_name}-container-${var.env}"
  #   container_port   = 80
  # }
}