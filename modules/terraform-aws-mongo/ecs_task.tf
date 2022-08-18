resource "aws_ecs_task_definition" "gck_mongo" {
  count = var.mongo_node_count
  network_mode             = "awsvpc"
  family                   = "mongo0${count.index + 1}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_0${count.index+1}"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "mongo0${count.index+1}-container-${var.env}-${var.region}"
    image     = var.image
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_0${count.index+1}"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "${aws_route53_zone.private.name}."},
      { "name" : "SUB_DOMAIN", "value" : "mongo0${count.index+1}.${aws_route53_zone.private.name}." },
      { "name" : "DATA_DIR", "value" : "mongo0${count.index+1}" },
      count.index == 0 
        ? [{ "name" : "LEADER", "value" : "true" }] 
        : [{ "name" : "LEADER", "value" : "false" }]
    ]
    linuxParameters = {
      initProcessEnabled: var.env == "dev" || var.env == "staging" ? true : false
    }
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo/${var.region}",
        awslogs-region : var.region,
        awslogs-stream-prefix : "ecs",
        awslogs-create-group: "true"
      }
    }
  }])
}