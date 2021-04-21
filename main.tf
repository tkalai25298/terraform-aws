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
  region  = "eu-west-2"
}

resource "aws_vpc" "bc-dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags =  {
     Name = "bc-dev-vpc"
  }
}

resource "aws_subnet" "bc-dev-subnet1" {
  vpc_id = aws_vpc.bc-dev-vpc.id

  cidr_block = "10.0.0.0/24"

  tags =  {
     Name = "bc-dev-subnet1"
  }
}

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

resource "aws_instance" "bc-tf-dev" {
//  count = 10
  ami           = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.bc-dev-subnet1.id
  instance_type = "t2.micro"
  tags = {
    Name = "bc-tf-dev"
  }
}

