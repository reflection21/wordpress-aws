# wordpress sg
resource "aws_security_group" "wordpress" {
  name        = "wordpress-sg"
  description = "Sg for wordpress server"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-wordpress-sg"
  }
}

# load balancer sg
resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "sg for load balancer"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-load-balancer-sg"
  }
}

# allow all trafic to loadbalancer from internet on 80 port
resource "aws_security_group_rule" "ingress_traffic_to_lb_80" {
  description       = "allow traffic to lb"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}


# allow traffic to app from lb
resource "aws_security_group_rule" "egress_traffic_from_lb_80" {
  description              = "allow traffic to app from lb"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress.id
  security_group_id        = aws_security_group.load_balancer.id
}

# allow traffic to app from lb
resource "aws_security_group_rule" "ingress_traffic_to_wordpress_80" {
  description              = "allow traffic to wordpress from lb"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.wordpress.id
}

resource "aws_security_group_rule" "egress_wordpress_to_internet" {
  description       = "allow egress trafic of wordpress into internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
}

resource "aws_security_group_rule" "ingress_8081_wordpress" {
  description              = "ingress 8081 port"
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.wordpress.id
}

resource "aws_security_group_rule" "egress_8081_alb" {
  description              = "egress 8081 port"
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress.id
  security_group_id        = aws_security_group.load_balancer.id
}
