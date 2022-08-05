resource "aws_ecs_task_definition" "gck_portal" {
  network_mode             = "awsvpc"
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.app_name}-container-${var.env}"
    image     = "${var.ecr_repo_main_account}.dkr.ecr.${var.ecr_repo_main_region}.amazonaws.com/gck_portal:${var.image_version}"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
      hostPort      = 80
    }]
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