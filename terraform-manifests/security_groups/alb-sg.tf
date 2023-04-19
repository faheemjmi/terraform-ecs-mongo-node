resource "aws_security_group" "alb_sg" {
  name = "${var.app_name}_${var.app_env}_alb_sg"
  description = "Allow HTTP and HTTPS from PB"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.pb_cidr_block
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
      Name = "${var.app_name}_${var.app_env}_alb_sg"
  }
}

output "alb_sg_id" {
  value = "${aws_security_group.alb_sg.id}"
}