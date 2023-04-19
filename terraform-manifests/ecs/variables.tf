# From other modules
variable "public_subnet_id" {}
variable "alb_sg_id" {}
variable target_group_arns {}
variable app_name {}
variable app_env {}
variable image_name {}
variable "app_type" {}
variable "ecs_role_arn" {}
#Resource Config
variable "cpu" {
  description = "cpu capacity"
  type = number
  default = 1024
}
variable "memory" {
  description = "alloted memory"
  type = number
  default = 2048
}
variable "container_port" {
  description = "Container Port"
  type = number
  default = 80
}
variable "host_port" {
  description = "Host Port"
  type = number
  default = 80
}

 variable "env_variables" {
   description = "env variables"
   type = list(map(string))
   default = []
   #default = [{"name": "MONGODB_URL", "value": "123"}]
 }
