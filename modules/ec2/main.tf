resource "aws_instance" "my_instance" {

  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [var.sec_groups]
  subnet_id = var.subnet_id
  iam_instance_profile = var.instance_profile
  user_data = data.template_file.userdata.rendered
  associate_public_ip_address = var.public_ip

  root_block_device {
    volume_size = var.volume_size
  }
  
   tags = {
    Name = var.instance_tags
  }
  lifecycle {
    create_before_destroy = true
    // ignore_changes = [user_data]
  }

}

locals {
  datacenter = var.region
  bind_addr = "{{ GetPrivateIP }}"
  aws_tag = var.redis_consul_tag
  aws_key = var.redis_consul_key
}

data "template_file" "userdata" {
  template = file("${path.module}/template/userdata.tpl")
  vars = {
    datacenter = local.datacenter
    aws_tag = local.aws_tag
    aws_key = local.aws_key
    bind_addr = local.bind_addr
  }
}
