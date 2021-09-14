variable "source_sec_group_1" {
  description = "The 1st security group."
  type        = string

  validation {
    condition     = can(regex("^sg-", var.source_sec_group_1))
    error_message = "The input is not a valid security group name."
  }
}

variable "source_sec_group_2" {
  description = "The 2nd security group."
  type        = string

  validation {
    condition     = can(regex("^sg-", var.source_sec_group_2))
    error_message = "The input is not a valid security group name."
  }
}

variable "protocols" {
  description = "The protocols for the rule. Default is allow all."
  type        = string
  default     = "-1"
}

variable "to_port" {
  description = "To port for communication between the security groups."
  type        = number
  default     = 0
  validation {
    condition     = var.to_port < 65536
    error_message = "The are only 65536 ports."
  }
}
variable "from_port" {
  description = "From port for communication between the security groups."
  type        = number
  default     = 0
  validation {
    condition     = var.from_port < 65536
    error_message = "The are only 65536 ports."
  }
}