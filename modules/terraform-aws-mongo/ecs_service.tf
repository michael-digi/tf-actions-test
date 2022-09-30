resource "aws_ecs_service" "gck_mongo" {
  count = var.mongo_node_count
  name                               = "mongo0${count.index+1}-service-${var.env}-${var.region}"
  cluster                            = aws_ecs_cluster.gck_mongo.id
  task_definition                    = aws_ecs_task_definition.gck_mongo[count.index].arn
  desired_count                      = count.index == 0 ? 0 : 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_execute_command = (var.env == "dev" || var.env == "staging") ? true : false

  network_configuration {
    security_groups  = [aws_security_group.mongo.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}