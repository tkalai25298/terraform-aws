variable "vpc_id" {
  description = "id of vpc that desired subnet belongs to"
}

variable "availability_zone" {
  type = string
  description = "ID of the Availability Zone for the subnet."
}