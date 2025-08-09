resource "aws_security_group_rule" "allow_ssh_to_nodes" {
  description       = "Allow SSH access to EKS nodes"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "nodes_to_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.eks.node_security_group_id
  self              = true
}