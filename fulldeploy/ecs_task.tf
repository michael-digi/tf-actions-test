resource "aws_ecs_task_definition" "gck_portal" {
  network_mode             = "awsvpc"
  family                   = "gck-portal"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "gck-portal-container-prod"
    image     = "417363389520.dkr.ecr.us-east-1.amazonaws.com/gck_portal:latest"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
      hostPort      = 80
    }]
  }])
}