resource "aws_instance" "bc-tf-dev" {
  ami = var.ami
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sec_groups]
  associate_public_ip_address = var.public_ip
  instance_type = var.instance_type

   tags = {
    Name = "bc-tf-dev"
  }
}

