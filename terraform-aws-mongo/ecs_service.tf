resource "aws_ecs_service" "gck_mongo1" {
  name                               = "mongo1-service-${var.env}"
  cluster                            = aws_ecs_cluster.gck_mongo.id
  task_definition                    = aws_ecs_task_definition.gck_mongo1.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = ["sg-03563a0c02eb3fda2", "sg-0543b24b4f1ea21d5"]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "gck_mongo2" {
  name                               = "mongo2-service-${var.env}"
  cluster                            = aws_ecs_cluster.gck_mongo.id
  task_definition                    = aws_ecs_task_definition.gck_mongo2.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = ["sg-03563a0c02eb3fda2", "sg-0543b24b4f1ea21d5"]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "gck_mongo3" {
  name                               = "mongo3-service-${var.env}"
  cluster                            = aws_ecs_cluster.gck_mongo.id
  task_definition                    = aws_ecs_task_definition.gck_mongo3.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups = ["sg-03563a0c02eb3fda2", "sg-0543b24b4f1ea21d5"]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}
