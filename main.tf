terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c398cb65a93047f2"
  instance_type = "t3.small"

  key_name = "iac-alura"

  tags = {
    Name = "Instancia Terraform"
  }
}
