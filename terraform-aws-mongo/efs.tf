resource "aws_efs_file_system" "mongo_replica" {
  creation_token = "backups"
  encrypted      = true
}

resource "aws_efs_mount_target" "mongo_replica" {
  count          = var.subnets
  file_system_id = aws_efs_file_system.mongo_replica.id
  subnet_id      = element(var.private_subnet_ids.*.id, count.index)
  security_groups = [
    "sg-046ec0e68b6c1eed9"
  ]
}