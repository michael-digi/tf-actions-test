resource "aws_ecs_task_definition" "gck_portal" {
  network_mode             = "awsvpc"
  family                   = "${var.app_name}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.app_name}-container-${var.environment}"
    image     = "${var.ecr_repo_main_account}.dkr.ecr.${var.ecr_repo_main_region}.amazonaws.com/gck_portal_${var.env}:${var.version}" // temp, testing
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
      hostPort      = 0
    }]
  }])
}