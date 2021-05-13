terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  region = "eu-west-2"
  availability = "eu-west-2a"
}

//creating custom vpc1
data "aws_vpc" "default" {
  default = true
}

//creating subnet in vpc1
data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = local.availability
}


//security groups for ssh(22),http(80),appln(tcp-8080) & outbound traffic(anyprotocol=-1)
resource "aws_security_group" "sec-group" {
  name        = "allow_traffic_1"
  description = "Allow ssh,http & tcp(appln)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH to instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    description = "httpd helloworld"
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sec-group"
  }
}

//creating ec1 instance in vpc1 - subnet1
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}


module "ec2_instance" {
 source = "./modules/ec2"

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  sec_groups = aws_security_group.sec-group.id
  subnet_id = data.aws_subnet.default.id
}
