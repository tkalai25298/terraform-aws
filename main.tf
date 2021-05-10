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

//creating custom vpc1
resource "aws_vpc" "bc-dev-vpc" {
  
  cidr_block = "10.0.0.0/16"

  tags =  {
     Name = "bc-dev-vpc"
  }
}

//creating subnet in vpc1
resource "aws_subnet" "bc-dev-subnet1" {
  vpc_id = aws_vpc.bc-dev-vpc1.id

  cidr_block = "10.0.0.0/16"

  tags =  {
     Name = "bc-dev-subnet1"
  }
}

//creating internet gateway which provides access from outside via internet
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.bc-dev-vpc1.id

  tags = {
    Name = "gateway"
  }
}

//creating route table that routes the traffic 
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.bc-dev-vpc1.id

  tags = {
    Name = "Main route table"
  }
}

//adding route1 to route-table (directing all traffic ipv4cidr block to internet gateway)
resource "aws_route" "internet-connect" {
  route_table_id = aws_route_table.route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateway.id
}

//associating the subnet and route table 
resource "aws_route_table_association" "internet-gateway" {
  route_table_id = aws_route_table.route-table.id
  subnet_id = aws_subnet.bc-dev-subnet1.id
}


//security groups for ssh(22),http(80),appln(tcp-3000) & outbound traffic(anyprotocol=-1)
resource "aws_security_group" "sec-group" {
  name        = "allow_traffic"
  description = "Allow ssh,http & tcp(appln)"
  vpc_id      = aws_vpc.bc-dev-vpc1.id

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
    from_port = 3000
    protocol = "tcp"
    to_port = 3000
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

//resource "aws_instance" "bc-tf-dev" {
////  count = 10
//  ami           = data.aws_ami.ubuntu.id
//  subnet_id = aws_subnet.bc-dev-subnet1.id
//  vpc_security_group_ids = [aws_security_group.sec-group.id]
//  associate_public_ip_address = true
//  instance_type = "t2.micro"
//  tags = {
//    Name = "bc-tf-dev"
//  }
//}

module "ec2_instance" {
  source = "./modules/ec2"

  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.bc-dev-subnet1.id
  vpc_security_group_ids = [aws_security_group.sec-group.id]
  associate_public_ip_address = true
  instance_type = "t2.micro"
}
