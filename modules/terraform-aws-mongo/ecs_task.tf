resource "aws_ecs_task_definition" "gck_mongo1" {
  network_mode             = "awsvpc"
  family                   = "mongo01"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_01"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "mongo01-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_01"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "${aws_route53_zone.private.name}." },
      { "name" : "SUB_DOMAIN", "value" : "mongo01.${aws_route53_zone.private.name}." },
      { "name" : "DATA_DIR", "value" : "mongo01" },
      { "name" : "LEADER", "value" : "true" }
    ]
    linuxParameters = {
      initProcessEnabled: var.env == "dev" || var.env == "staging" ? true : false
    }
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs",
        awslogs-create-group: "true"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "gck_mongo2" {
  network_mode             = "awsvpc"
  family                   = "mongo02"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_2"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "mongo02-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_02"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "${aws_route53_zone.private.name}." },
      { "name" : "SUB_DOMAIN", "value" : "mongo02.${aws_route53_zone.private.name}." },
      { "name" : "DATA_DIR", "value" : "mongo02" },
      { "name" : "LEADER", "value" : "false" }
    ]
    linuxParameters = {
      initProcessEnabled: var.env == "dev" || var.env == "staging" ? true : false
    }
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs",
        awslogs-create-group: "true"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "gck_mongo3" {
  network_mode             = "awsvpc"
  family                   = "mongo03"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_03"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "mongo03-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_03"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "${aws_route53_zone.private.name}." },
      { "name" : "SUB_DOMAIN", "value" : "mongo03.${aws_route53_zone.private.name}." },
      { "name" : "DATA_DIR", "value" : "mongo03" },
      { "name" : "LEADER", "value" : "false" }
    ],
    linuxParameters = {
      initProcessEnabled: var.env == "dev" || var.env == "staging" ? true : false
    }
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs",
        awslogs-create-group: "true"
      }
    }
  }])
}