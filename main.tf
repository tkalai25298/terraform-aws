terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}


locals {
  region = "eu-west-2"
  availability = "eu-west-2a"
  tag_name = "bc-tf-aws-dev"
}

provider "aws" {
  profile = "default"
  region  = local.region
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

module "vpc" {
  source = "./modules/vpc"

  default = true
}

module "subnet" {
  source = "./modules/subnet"

  vpc_id = module.vpc.vpc-id
  availability_zone = local.availability

}

module "sec-groups" {
  source = "./modules/sec-groups"

  name = "allow_traffic_random"
  description = "allow ssh,http & tcp"
  vpc_id = module.vpc.vpc-id
  tag_name = local.tag_name

  ingress_rules = [{
    description = "HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "SSH to instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  },
    {
    description = "httpd helloworld"
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ]
  egress_rules = [{
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

}

module "ec2_instance" {
 source = "./modules/ec2"

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  sec_groups = module.sec-groups.subnet_id
  subnet_id = module.subnet.subnet_id
  tag_name = local.tag_name
}
