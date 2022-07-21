data "aws_caller_identity" "current" {}

resource "aws_ecs_task_definition" "gck_mongo1" {
  network_mode             = "awsvpc"
  family                   = "mongo"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskExecutionRole_production"
  task_role_arn            = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskRole_production"
  volume {
    name = "mongo_replica_1"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo1-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_replica_1"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "miked.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo1.miked.com." },
      { "name" : "DATA_DIR", "value" : "mongo1" },
      { "name" : "LEADER", "value" : "true" }
    ],
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "gck_mongo2" {
  network_mode             = "awsvpc"
  family                   = "mongo"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskExecutionRole_production"
  task_role_arn            = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskRole_production"
  volume {
    name = "mongo_replica_2"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo2-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_replica_2"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "miked.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo2.miked.com." },
      { "name" : "DATA_DIR", "value" : "mongo2" },
      { "name" : "LEADER", "value" : "false" }
    ],
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs"
      }
    }
  }])
}

resource "aws_ecs_task_definition" "gck_mongo3" {
  network_mode             = "awsvpc"
  family                   = "mongo"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskExecutionRole_production"
  task_role_arn            = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskRole_production"
  volume {
    name = "mongo_replica_3"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_replica.id
    }
  }
  container_definitions = jsonencode([{
    name      = "monogo3-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    mountPoints = [{
      containerPath : "/data"
      sourceVolume : "mongo_replica_3"
    }]
    "environment" = [
      { "name" : "DOMAIN", "value" : "miked.com." },
      { "name" : "SUB_DOMAIN", "value" : "mongo3.miked.com." },
      { "name" : "DATA_DIR", "value" : "mongo3" },
      { "name" : "LEADER", "value" : "false" }
    ],
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "mongo",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs"
      }
    }
  }])
}