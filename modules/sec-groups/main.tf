resource "aws_security_group" "sec-groups-for-ec2" {
  name = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = var.tag_name
  }
}

resource "aws_security_group_rule" "self_inter_com_ec2" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sec-groups-for-ec2.id
  to_port           = 0
  self              = true
  type              = "ingress"
}