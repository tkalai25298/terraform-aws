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
  tag_name = "consul-redis"
  instance_count = "1"
}

provider "aws" {
  profile = "default"
  region  = local.region
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

  name = "allow_traffic_ec2_consul_redis"
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
    description = "orderer port"
    from_port = 7050
    protocol = "tcp"
    to_port = 7050
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "Peer 1 port"
    from_port = 7051
    protocol = "tcp"
    to_port = 7051
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "Peer2 port"
    from_port = 7052
    protocol = "tcp"
    to_port = 7052
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "chaincode port"
    from_port = 7053
    protocol = "tcp"
    to_port = 7053
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "port"
    from_port = 7054
    protocol = "tcp"
    to_port = 7054
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "Vault port"
    from_port = 8200
    protocol = "tcp"
    to_port = 8200
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
    description = "redis port"
    from_port = 6379
    protocol = "tcp"
    to_port = 6379
    cidr_blocks = ["0.0.0.0/0"]
  },
   {
    description = "consul LAN port"
    from_port = 8301
    protocol = "tcp"
    to_port = 8301
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "consul HTTP port"
    from_port = 8500
    protocol = "tcp"
    to_port = 8500
    cidr_blocks = ["0.0.0.0/0"]
  } ]
  egress_rules = [{
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]


}

module "ami" {
  source = "./modules/ubuntu-image"
}

module "iam" {
  source = "./modules/IAM"
}

module "ec2_instance" {
 source = "./modules/ec2"
 instance_count = local.instance_count
  ami = "ami-02aa596c783234844"
  instance_type = "t3.medium"
  sec_groups = module.sec-groups.SecGroup
  subnet_id = module.subnet.subnet_id
  tag_name = local.tag_name
  volume_size = "10"
  instance_profile = module.iam.instance_profile

}
