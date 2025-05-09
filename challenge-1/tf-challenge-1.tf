provider "aws" {
  # version = "~> 2.54"
  region = "eu-west-3"
}

provider "digitalocean" {}

terraform {
  # required_version = "0.12.31"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "aws_eip" "kplabs_app_ip" {
  # vpc = true
  domain   = "vpc"
  instance = aws_instance.web.id
}

#####

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Challenge_1"
  }
}