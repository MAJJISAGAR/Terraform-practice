variable "ec2-type" {
  type = string
  default = "t2.micro"
}

variable "ec2-ami" {
  type = string
  default = "ami-0af9569868786b23a"
}

variable "vpc-cidr" {
  type = string
  default = "192.168.0.0/24"
}

variable "sub-cidr" {
  type = string
  default = "192.168.0.0/26"
}