# From other modules
#
variable "public_subnet_id" {}
variable "alb_sg_id" {}
variable vpc_id {}
#variable certificate_arn {}
variable "alb_name" {}
variable "healthcheck_path" {
  description = "Healthcheck Path"
  type = string
  default = "/"
}