resource "aws_ecs_task_definition" "gck_mongo1" {
  network_mode             = "awsvpc"
  family                   = "mongo"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "monogo1-container-${var.env}"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/mongocluster:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 27017
      hostPort      = 27017
    }]
  }])
}