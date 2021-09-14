variable "name" {
  type = string
  description = "name of the security group"
}

variable "description" {
  type = string
  description = "description of security group "
}
variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "ingress_rules" {
  type = list(object({
    description = string
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))

  default = [
    { description = "HTTP port"
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
    }
  ]
}

variable "egress_rules" {
  type = list(object({
    description = string
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))

  default = [{
    description = "egress rules for opening all ports(outbound) by default"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tag_name" {
  default = "consul-redis-sec-groups"
  description = "tag for security groups"
  type = string
}
