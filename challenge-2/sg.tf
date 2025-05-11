resource "aws_security_group" "security_group_payment_app" {
  name        = var.sg_name
  description = "Application Security Group"
  depends_on  = [aws_eip.example]

  # Below ingress allows HTTPS  from DEV VPC
  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  # Below ingress allows APIs access from DEV VPC

  ingress {
    from_port   = var.dev_api_port
    to_port     = var.dev_api_port
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  # Below ingress allows APIs access from Prod App Public IP.

  ingress {
    from_port   = var.prod_api_port
    to_port     = var.prod_api_port
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.example.public_ip}/32"]
  }

  egress {
    from_port   = var.splunk
    to_port     = var.splunk
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.sg_name
    Owner       = "Team Infra"
    stack       = "DEV"
    description = "Application Security Group"
  }
}