resource "aws_efs_file_system" "mongo_replica" {
  creation_token = "mongo-replica-${var.env}-${var.region}"
  encrypted      = true
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.mongo_replica.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "mongo_replica" {
  for_each       = toset(var.private_subnets)
  file_system_id = aws_efs_file_system.mongo_replica.id
  subnet_id      = each.key
  security_groups = [
    aws_security_group.efs.id,
  ]
}