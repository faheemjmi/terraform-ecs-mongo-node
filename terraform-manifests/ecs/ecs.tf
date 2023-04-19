resource "aws_ecs_cluster" "app_cluster" {
    name  = "${var.app_name}-${var.app_env}"
}