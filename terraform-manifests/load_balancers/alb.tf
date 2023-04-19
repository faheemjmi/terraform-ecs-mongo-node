# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.6.1"

  #name = "${var.app_name}-${var.app_env}-alb"
  name = "${var.alb_name}-alb"
  load_balancer_type = "application"
  vpc_id = var.vpc_id
  #subnets = [ module.vpc.public_subnets[0],module.vpc.public_subnets[1] ]
  subnets  = var.public_subnet_id
  security_groups = ["${var.alb_sg_id}"]
  # Listeners
   # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type = "forward"
    }
  ]  
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 100
      health_check = {
        enabled             = true
        interval            = 30
        path                = "${var.healthcheck_path}" #"/goals"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      tags = {Name = "${var.alb_name}-tg"} #local.common_tags # Target Group Tags 
    },
   ]

   
  
  tags = {Name = "${var.alb_name}-alb"} #local.common_tags # ALB Tags
}

