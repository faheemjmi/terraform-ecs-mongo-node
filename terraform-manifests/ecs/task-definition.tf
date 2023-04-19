
locals {

  environment = jsonencode(var.env_variables)
  final_environment = local.environment == "[]" ? "null" : local.environment
}

#resource "aws_ecs_task_definition" "goals_backend" {

resource "aws_ecs_task_definition" "ecs_task_definition" {
   family = "${var.app_name}-${var.app_env}-${var.app_type}" #"goals-backend"
   requires_compatibilities = ["FARGATE"]
   network_mode = "awsvpc"
   cpu = var.cpu    
   memory = var.memory
   execution_role_arn = "${var.ecs_role_arn}"
   container_definitions    = <<DEFINITION
    [
      {
        "name": "${var.app_name}-${var.app_env}-${var.app_type}",
        "image": "${var.image_name}",
        "essential": true,
        "portMappings": [
          {
            "containerPort": ${var.container_port},
            "hostPort": ${var.host_port}
          }
        ],
        "memory": ${var.memory},
        "cpu": ${var.cpu},
        "environment": ${local.final_environment}
      }
    ]
    DEFINITION

}

# resource "aws_ecs_task_definition" "goals_frontend" {
#    family = "goals-frontend"
#    requires_compatibilities = ["FARGATE"]
#    network_mode = "awsvpc"
#    cpu = 1024    
#    memory = 2048
#    execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
#    container_definitions    = <<DEFINITION
#     [
#       {
#         "name": "goals-frontend",
#         "image": "itsfaheem/goals-react:${var.image_version}",
#         "essential": true,
#         "portMappings": [
#           {
#             "containerPort": 80,
#             "hostPort": 80
#           }
#         ],
#         "memory": 2048,
#         "cpu": 1024,
#       }
#     ]
#     DEFINITION

# }