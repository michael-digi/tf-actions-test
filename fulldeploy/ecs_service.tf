resource "aws_ecs_service" "gck_portal" {
  name                               = "gck-portal-service-${var.environment}"
  cluster                            = aws_ecs_cluster.gck_portal.id
  task_definition                    = aws_ecs_task_definition.gck_portal.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = module.networking.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.gck_portal.arn
    container_name   = "gck-portal-container-${var.environment}"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}