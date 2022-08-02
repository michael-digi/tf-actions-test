terraform {
  required_version = ">=0.12.24"
}

resource "aws_ecr_repository" "repos" {
  for_each = var.repository_list
  name     = each.value

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  for_each   = var.repository_list
  repository = each.value

  depends_on = [aws_ecr_repository.repos]

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.images_to_keep} images with `any` tag",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "template_file" "push_allowed_policy" {
  template = <<EOF
{
    "Sid": "AllowCrossAccountPush",
    "Effect": "Allow",
    "Principal": {
        "AWS": [${join(",", formatlist("\"arn:aws:iam::%s:root\"", var.push_account_list))}]
    },
    "Action": [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
    ]
}
EOF
}

data "template_file" "pull_allowed_policy" {
  template = <<EOF
{
    "Sid": "AllowCrossAccountPull",
    "Effect": "Allow",
    "Principal": {
        "AWS": [${join(",", formatlist("\"arn:aws:iam::%s:root\"", var.pull_account_list))}]
    },
    "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
    ]
}
EOF
}

# This is the stupidest terraform I've ever had to write. Good lord kill me.
resource "aws_ecr_repository_policy" "policy" {
  for_each   = var.repository_list
  repository = each.value

  depends_on = [aws_ecr_repository.repos]

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      ${join(",", compact(tolist([
  length(var.pull_account_list) == 0 ? "" : data.template_file.pull_allowed_policy.rendered,
  length(var.push_account_list) == 0 ? "" : data.template_file.push_allowed_policy.rendered
])))}
    ]
}
EOF
}
