data "aws_subnet" "default" {
  vpc_id = var.vpc_id
  availability_zone = var.availability_zone
}