terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "porta_http" {
    description = "porta http"
    default = 80
    type = number
}

variable "porta_https" {
    description = "porta https"
    default = 443
    type = number
}

resource "aws_vpc" "vpc_learnlink" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_learnlink"
  }
}

resource "aws_subnet" "sn_learnlink_public" {
  vpc_id     = aws_vpc.vpc_learnlink.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "sn_learnlink_public"
  }
}

resource "aws_subnet" "sn_learnlink_private" {
  vpc_id     = aws_vpc.vpc_learnlink.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "sn_learnlink_private"
  }
}


  resource "aws_security_group" "sg_learnlink_backend" {
  vpc_id = aws_vpc.vpc_learnlink.id
  name   = "sg_learnlink_backend"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_learnlink_frontend" {
  vpc_id = aws_vpc.vpc_learnlink.id
  name   = "sg_learnlink_frontend"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.porta_http
    to_port     = var.porta_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.porta_http
    to_port     = var.porta_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

resource "aws_instance" "ec2-learnlink-frontend" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2-learnlink-frontend"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
    volume_type = "gp3"
  }

  security_groups = [aws_security_group.sg_learnlink_frontend.id]
  key_name        = "aula_iac"
  subnet_id       = aws_subnet.sn_learnlink_public.id
}

resource "aws_instance" "ec2-learnlink-backend" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2-learnlink-backend"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
    volume_type = "gp3"
  }

  security_groups = [aws_security_group.sg_learnlink_backend.id]
  key_name        = "aula_iac"
  subnet_id       = aws_subnet.sn_learnlink_private.id
}
