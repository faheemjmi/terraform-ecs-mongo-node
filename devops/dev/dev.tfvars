#Main Variables
app_name = "goals"
app_env = "dev" 
aws_region = "us-east-1"
key_name = "fahnoi-key"

#Application Variables
backend_image = "itsfaheem/goals-node"
frontend_image = "itsfaheem/goals-react"
# VPC variables
vpc_cidr_block = "172.31.0.0/22"
vpc_name = "demo"
vpc_availability_zones = ["us-east-1a", "us-east-1b"]
vpc_public_subnets = ["172.31.0.0/26", "172.31.0.64/26"]
vpc_private_subnets = ["172.31.0.192/26", "172.31.1.0/26"]
vpc_database_subnets= []
vpc_create_database_subnet_group = false 
vpc_create_database_subnet_route_table = false   
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true
#Route-53 variables
#certificate_arn = "arn:aws:acm:us-east-1:752969307050:certificate/b3a83143-f42c-4f11-b386-22604bf93be8"
domain_name = "tools.pitneycloud.com"
# Security group variables
pb_cidr_block = ["165.225.124.78/32","122.161.82.144/32"]

#MongoDB ENV variables
MONGODB_URL = "testURL"
MONGODB_NAME = "testDB"
MONGODB_USERNAME = "itsfaheem"
MONGODB_PASSWORD = "testPWD"
image_version = "latest"
