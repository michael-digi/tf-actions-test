resource "aws_ecs_task_definition" "gck_mongo1" {
  network_mode             = "awsvpc"
  family                   = "mongo1"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_1"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo1-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongo_cluster_staging:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_1"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "gocheck-${var.env}.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo01.gocheck-${var.env}.com." },
      { "name" : "DATA_DIR", "value" : "mongo01" },
      { "name" : "LEADER", "value" : "true" }
    ],
    linuxParameters: {
      initProcessEnabled: true
    }, 
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
  family                   = "mongo2"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_2"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo2-container-${var.env}"
    image     = "952899752506.dkr.ecr.us-east-1.amazonaws.com/mongo_cluster_staging:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_2"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "gocheck-${var.env}.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo02.gocheck-${var.env}.com." },
      { "name" : "DATA_DIR", "value" : "mongo02" },
      { "name" : "LEADER", "value" : "false" }
    ],
    linuxParameters: {
      initProcessEnabled: true
    },
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
  family                   = "mongo3"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  volume {
    name = "mongo_volume_3"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo3-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongo_cluster_staging:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_volume_3"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "gocheck-${var.env}.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo03.gocheck-${var.env}.com." },
      { "name" : "DATA_DIR", "value" : "mongo03" },
      { "name" : "LEADER", "value" : "false" }
    ],
    linuxParameters: {
      initProcessEnabled: true
    },
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