resource "aws_iam_role" "ecs_task_role" {
  name = "${var.app_name}-ECSTaskRole-${var.env}-${var.region}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ECSTaskExecutionRole-${var.env}-${var.region}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "ecs_fargate_exec_portal" {
  name   = "ecs-fargate-exec-portal-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_fargate_exec_portal.json
}

data "aws_iam_policy_document" "ecs_fargate_exec_portal" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ecs:ExecuteCommand",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_cloudwatch_portal" {
  name   = "ecs-cloudwatch-portal-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_cloudwatch_portal.json
}

data "aws_iam_policy_document" "ecs_cloudwatch_portal" {
  statement {
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_cloudwatch_portal" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_cloudwatch_portal.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_fargate_exec_portal" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_fargate_exec_portal.arn
}