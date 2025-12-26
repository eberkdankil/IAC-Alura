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

  /*  user_data = <<EOF

#!/bin/bash

sudo apt update && sudo apt upgrade -y
cd /home/ubuntu
echo "<h1>Hello World</h1>" > index.html
nohup busybox httpd -f -p 8080 &

EOF
*/

  tags = {
    Name = "Instancia Terraform"
  }
}
