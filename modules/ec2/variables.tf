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
