resource "aws_ecs_cluster" "gck_mongo" {
  name = "mongo-cluster-${var.env}-${var.region}"
}