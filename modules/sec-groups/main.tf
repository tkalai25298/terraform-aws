// resource "aws_security_group" "sec-groups-for-ec2" {
//   name = var.name
//   vpc_id = var.vpc_id

//   tags = {
//     Name = var.tag_name
//   }
// }

resource "aws_security_group" "sec-groups-for-ec2" {
  name                   = var.name
  vpc_id                 = var.vpc_id
  description            = "This is a security group for redis-consul"
  revoke_rules_on_delete = true // Making sure other rules added get deleted before we delete this
}

resource "aws_security_group_rule" "ingress_commn" {
    type              = "ingress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = var.server-sec-group-id
    security_group_id = aws_security_group.sec-groups-for-ec2.id
}

resource "aws_security_group_rule" "ingress" {
  count             = length(var.ingress_rules)
  description       = var.ingress_rules[count.index].description
  from_port         = var.ingress_rules[count.index].from_port
  protocol          = var.ingress_rules[count.index].protocol
  security_group_id = aws_security_group.sec-groups-for-ec2.id
  to_port           = var.ingress_rules[count.index].to_port
  cidr_blocks       = var.ingress_rules[count.index].cidr_blocks
  type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  count             = length(var.egress_rules)
  description       = var.egress_rules[count.index].description
  from_port         = var.egress_rules[count.index].from_port
  protocol          = var.egress_rules[count.index].protocol
  security_group_id = aws_security_group.sec-groups-for-ec2.id
  to_port           = var.egress_rules[count.index].to_port
  cidr_blocks       = var.egress_rules[count.index].cidr_blocks
  type              = "egress"
}