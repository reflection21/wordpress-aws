# alb sg
resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "sg for load balancer"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-load-balancer-sg"
  }
}
# wordpress sg
resource "aws_security_group" "wordpress" {
  name        = "wordpress-sg"
  description = "Sg for wordpress server"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-wordpress-sg"
  }
}
# rds sg
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Sg for rds server"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.deployment_prefix}-rds-sg"
  }
}
# allow all trafic to loadbalancer from internet on 80 port
resource "aws_security_group_rule" "ingress_traffic_to_lb_80" {
  description       = "allow HTTP traffic to lb"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}

# allow all trafic to loadbalancer from internet on 80 port
resource "aws_security_group_rule" "ingress_traffic_to_lb_443_2" {
  description       = "allow HTTPS traffic to lb"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}
# egress all traffic 
resource "aws_security_group_rule" "egress_lb_traffic" {
  description       = "allow all traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
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
# outbound rule 
resource "aws_security_group_rule" "egress_wordpress_to_internet" {
  description       = "allow egress trafic of wordpress into internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
}
# ingress sonarqube port 9000
resource "aws_security_group_rule" "ingress_9000_wordpress" {
  description              = "ingress 9000 port"
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.wordpress.id
}
# ingress nexus port 5000
resource "aws_security_group_rule" "ingress_5000_wordpress" {
  description              = "ingress 5000 port"
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = aws_security_group.wordpress.id
}
# inbound rule for rds
resource "aws_security_group_rule" "inbound_rule_mysql" {
  description              = "ingress 3306 port"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress.id
  security_group_id        = aws_security_group.rds.id
}
# extra access
resource "aws_security_group_rule" "extra_inbound_access" {
  count             = var.add_extra_cidr_blocks ? 1 : 0
  type              = "ingress"
  description       = "Allow inbound access for additional CIDR blocks"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.extra_cidr_blocks
  security_group_id = aws_security_group.rds.id
}

resource "aws" "name" {
  
}