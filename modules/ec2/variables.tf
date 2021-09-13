variable "instance_count" {
  default = "1"
  type = number
}

variable "volume_size" {
  default = "30"
  description = "volume size for aws-instance"
  type = number
}

variable "instance_tags" {
  type = string
  default = "consul-redis"
}

variable "ami" {
  description = "ami image to run instance"
  type = string
  validation {
    condition     = can(regex("^ami-", var.ami))
    error_message = "The input is not a valid ami."
  }
}

variable "subnet_id" {
  description = "The subnet to join."
  type = string

  validation {
    condition     = can(regex("^subnet-", var.subnet_id))
    error_message = "The input is not a valid subnet id."
  }
}

variable "sec_groups" {
  description = "The security group to apply to the vm."
  type = string
  validation {
    condition     = can(regex("^sg-", var.sec_groups))
    error_message = "The input is not a valid security group name."
  }
}

variable "public_ip" {
  description = "To enable public ip being assigned to the vm."
  type = bool
  default = true
}

variable "instance_type" {
  description = "The type of machine, as i  the specification of the vm."
  type = string
}

variable "tag_name" {
  type = string
  description = "tag for the ec2 instance server"
  default = "consul-redis"
}

variable "redis_consul_tag" {
  type = string
  description = "tag for redis-consul cluster"
  default = "playground"
}

variable "redis_consul_key" {
  type = string
  description = "key for redis-consul cluster"
  default = "server"
}

variable "region" {
  type = string
  default = "gcp-eu-west-2"
}

variable "instance_profile" {
  type = string
  description = "aws IAM policy"
}