provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "vpc-1" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
    Name = "MY-new-vpc"
  }
}

resource "aws_subnet" "pub-sub" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = var.sub-cidr
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "My-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rtb-ass" {
  subnet_id = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc-1.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami = var.ec2-ami
  instance_type = var.ec2-type
  key_name = "majji@key"
  subnet_id = aws_subnet.pub-sub.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  depends_on = [ aws_security_group.sg ]
  tags = {
    Name = "My-Instance"
  }
}
