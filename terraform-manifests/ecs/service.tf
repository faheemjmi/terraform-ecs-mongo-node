resource "aws_ecs_service" "ecs_service" {
    name = "${var.app_name}-${var.app_env}-${var.app_type}"
    cluster = "${aws_ecs_cluster.app_cluster.id}"
    task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"
    desired_count = 1
    network_configuration {
      subnets = var.public_subnet_id
      security_groups = ["${var.alb_sg_id}"]
      assign_public_ip = true
    }

    load_balancer {
    target_group_arn = var.target_group_arns[0]
    container_name   = "${var.app_name}-${var.app_env}-${var.app_type}"
    container_port   = 80
  }

}