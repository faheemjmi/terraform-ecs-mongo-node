# PB CIDR Block
variable "pb_cidr_block" {
  description = "PB CIDR Block"
  type = list(string)
  default = ["47.15.10.156/32"]
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string 
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "VPC ID"
  type = string 
  default = "vpc123456789"
}

variable app_name {}
variable app_env {}