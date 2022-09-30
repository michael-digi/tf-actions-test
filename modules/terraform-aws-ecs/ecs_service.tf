data "aws_security_group" "mongo_access" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "mongo-access-${var.env}-${var.region}"
    Env = "${var.env}"
    Region = "${var.region}"
  }
}

resource "aws_ecs_service" "gck_portal" {
  name                               = "${var.app_name}-service-${var.env}-${var.region}"
  cluster                            = aws_ecs_cluster.gck_portal.id
  task_definition                    = aws_ecs_task_definition.gck_portal.arn
  desired_count                      = var.num_containers
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = [
      data.aws_security_group.mongo_access.id
    ]
    subnets          = var.public_subnets
    assign_public_ip = true
  }

  # load_balancer {
  #   target_group_arn = aws_alb_target_group.gck_portal.arn
  #   container_name   = "${var.app_name}-container-${var.env}"
  #   container_port   = 443
  # }
}