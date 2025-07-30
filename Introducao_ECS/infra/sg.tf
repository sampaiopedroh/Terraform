# SG para parte pública (load balancer)
resource "aws_security_group" "sg_alb" {
    name   = "alb_ECS"
    vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_alb" {
    type              = "ingress"
    from_port         = 8000
    to_port           = 8000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "egress_alb" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.sg_alb.id
}

# SG para parte privada (rede com os ecs)
resource "aws_security_group" "privado" {
    name   = "privado_ECS"
    vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_ecs" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    source_security_group_id = aws_security_group.sg_alb.id
    security_group_id        = aws_security_group.privado.id
}

resource "aws_security_group_rule" "egress_ecs" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.privado.id
}