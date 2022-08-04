resource "aws_efs_file_system" "mongo_replica" {
  creation_token = "mongo_replica"
  encrypted      = true
}

resource "aws_efs_mount_target" "mongo_replica" {
  for_each       = toset(var.private_subnets)
  file_system_id = aws_efs_file_system.mongo_replica.id
  subnet_id      = each.key
  security_groups = [
    aws_security_group.vpc_access.id,
  ]
}