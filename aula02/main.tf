# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.16"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   region = "us-east-1"
# }

# variable "porta_http" {
#     description = "porta http"
#     default = 80
#     type = number
# }

# variable "porta_https" {
#     description = "porta https"
#     default = 443
#     type = number
# }

resource "aws_instance" "name" {
    ami = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.micro"

    tags = {
      Name = "ec2_iac_aula2"
    }

    ebs_block_device {
      device_name = "/dev/sda1"
      volume_size = 30
      volume_type = "gp3"
    }

    security_groups = [aws_security_group.sg_aula_iac.name, "default"]

    key_name = "aula_iac"

}


resource "aws_security_group" "sg_aula_iac" {
    name = "sg_aula_iac"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.porta_http
        to_port = var.porta_http
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = var.porta_http
        to_port = var.porta_http
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

