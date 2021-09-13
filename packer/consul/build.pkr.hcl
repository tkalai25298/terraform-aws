variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}


variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "image_ver" {
  type    = string
  default = "${env("AMI_VER")}"
}

variable "base_image" {
  type    = string
  default = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
}

variable "virtualization-type" {
  type    = string
  default = "hvm"
}

variable "root-device-type" {
  type    = string
  default = "ebs"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "image_owners" {
  type    = string
  default = "099720109477"
}

variable "ami_prefix" {
  type    = string
  default = "redis-consul"
}
//local varaible
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


//Building the ami image
build {

  sources = ["source.amazon-ebs.redis_consul_ami"]

    provisioner "ansible" {
        playbook_file = "./ansible/consul.yml"
    }

}

//Image base configuration defining 

source "amazon-ebs" "redis_consul_ami" {
  access_key    = "${var.aws_access_key}"
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  secret_key    = "${var.aws_secret_key}"

  source_ami_filter {
    filters = {
      name                = "${var.base_image}"
      root-device-type    = "${var.root-device-type}"
      virtualization-type = "${var.virtualization-type}"
    }
    most_recent = true
    owners      = ["${var.image_owners}"]
  }
  ssh_username = "${var.ssh_username}"
}