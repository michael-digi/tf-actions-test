resource "aws_ecs_task_definition" "gck_portal" {
  network_mode             = "awsvpc"
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.app_name}-container-${var.env}"
    image     = "952899752506.dkr.ecr.${var.ecr_repo_main_region}.amazonaws.com/gck_portal_staging:${var.image_version}"
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 443
      hostPort      = 443
    }]
    logConfiguration = {
      logDriver : "awslogs",
      options : {
        awslogs-group : "portal",
        awslogs-region : "us-east-1",
        awslogs-stream-prefix : "ecs",
        awslogs-create-group: "true"
      }
    }
  }])
}