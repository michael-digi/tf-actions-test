resource "aws_iam_role" "ecs_task_role" {
  name = "MongoEcsTaskRole-${var.env}-${var.region}"

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
  name = "MongoEcsTaskExecutionRole-${var.env}-${var.region}"

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

resource "aws_iam_policy" "ecs_route53" {
  name   = "ecs-route53-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_route53.json
}

data "aws_iam_policy_document" "ecs_route53" {
  statement {
    actions = [
      "route53:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_fargate_exec" {
  name   = "ecs-fargate-exec-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_fargate_exec.json
}

data "aws_iam_policy_document" "ecs_fargate_exec" {
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

resource "aws_iam_policy" "ecs_cloudwatch" {
  name   = "ecs-cloudwatch-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_cloudwatch.json
}

data "aws_iam_policy_document" "ecs_cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_secrets_manager" {
  name   = "ecs-secrets-manager-${var.env}-${var.region}"
  policy = data.aws_iam_policy_document.ecs_secrets_manager.json
}

data "aws_iam_policy_document" "ecs_secrets_manager" {
  statement {
    actions = [
      "secretsmanager:UpdateSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:ListSecrets",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:CreateSecret",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_mongo" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_cloudwatch" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_fargate_exec" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_fargate_exec.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_ecs_route53" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_route53.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_ecs_secrets_manager" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_secrets_manager.arn
}