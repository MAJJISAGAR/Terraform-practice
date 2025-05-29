provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  ami = var.ec2-ami
  instance_type = var.ec2-type
  tags = {
    Name = "My-Instance"
  }
}