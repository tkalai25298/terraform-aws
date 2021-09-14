resource "aws_security_group_rule" "Inter-comm-1" {
  from_port                = var.from_port
  protocol                 = var.protocols
  security_group_id        = var.source_sec_group_2
  source_security_group_id = var.source_sec_group_1
  to_port                  = var.to_port
  type                     = "ingress"
}

resource "aws_security_group_rule" "Inter-comm-2" {
  from_port                = var.from_port
  protocol                 = var.protocols
  security_group_id        = var.source_sec_group_1
  source_security_group_id = var.source_sec_group_2
  to_port                  = var.to_port
  type                     = "ingress"
}