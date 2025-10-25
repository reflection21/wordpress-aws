# alb
resource "aws_lb" "alb" {
  name                       = "application-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.lb_sg]
  subnets                    = var.public_subnet_id
  enable_deletion_protection = false
}

# listener server
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.validated_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

#Target group for app
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

#Target group attachment wordpress
resource "aws_lb_target_group_attachment" "wordpress_attach" {
  count            = length(var.wordpress_server)
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = var.wordpress_server
  port             = 80
}

resource "aws_lb_listener_rule" "adminer_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.adminer_tg.arn
  }

  condition {
    path_pattern {
      values = ["/adminer/"]
    }
  }
}

resource "aws_lb_target_group" "adminer_tg" {
  name     = "adminer-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

#Target group attachment wordpress
resource "aws_lb_target_group_attachment" "adminer_attach" {
  count            = length(var.wordpress_server)
  target_group_arn = aws_lb_target_group.adminer_tg.arn
  target_id        = var.wordpress_server
  port             = 8081
}

# dns record for alb
resource "aws_route53_record" "app_dns" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}