data "aws_caller_identity" "current" {}

resource "aws_ecs_task_definition" "gck_mongo1" {
  network_mode             = "awsvpc"
  family                   = "mongo"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskExecutionRole_production"
  task_role_arn            = "arn:aws:iam::417363389520:role/gck-portal-ecsTaskRole_production"
  container_definitions = jsonencode([{
    name      = "monogo1-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
    logConfiguration: {
          logDriver: "awslogs",
          options: {
            awslogs-group: "mongo",
            awslogs-region: "us-east-1",
            awslogs-stream-prefix: "ecs"
          }
        }
  }])
}