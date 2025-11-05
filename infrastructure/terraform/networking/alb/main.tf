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
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.validated_certificate

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# tg wordpress
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/wp-admin/install.php"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# tg adminer
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

# tg sonarqube
resource "aws_lb_target_group" "sonarqube_tg" {
  name     = "sonarqube-tg"
  port     = 9000
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

# tg nexus
resource "aws_lb_target_group" "nexus_tg" {
  name     = "nexus-tg"
  port     = 5000
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

# tg attachment wordpress
resource "aws_lb_target_group_attachment" "wordpress_attach" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = var.wordpress_server
  port             = 80
}

# tg attachment sonarqube
resource "aws_lb_target_group_attachment" "sonarqube_attach" {
  target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  target_id        = var.wordpress_server
  port             = 9000
}

# tg attachment nexus
resource "aws_lb_target_group_attachment" "nexus_attach" {
  target_group_arn = aws_lb_target_group.nexus_tg.arn
  target_id        = var.wordpress_server
  port             = 5000
}

# tg attachment adminer
resource "aws_lb_target_group_attachment" "adminer_attach" {
  target_group_arn = aws_lb_target_group.adminer_tg.arn
  target_id        = var.wordpress_server
  port             = 8081
}

# tg attachment adminer
resource "aws_lb_listener_rule" "adminer_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 15

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.adminer_tg.arn
  }

  condition {
    host_header {
      values = ["brigajani.website"]
    }
  }

  condition {
    path_pattern {
      values = ["/adminer/"]
    }
  }
}

# dns A record for alb
resource "aws_route53_record" "lb_record" {
  zone_id = var.route53_zone_id
  name    = "brigajani.website"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# dns A record for alb
resource "aws_route53_record" "lb_record_www" {
  zone_id = var.route53_zone_id
  name    = "sonar"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# dns A record for alb
resource "aws_route53_record" "lb_record_api" {
  zone_id = var.route53_zone_id
  name    = "nexus"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# www.brigajani.website → WordPress
resource "aws_lb_listener_rule" "www_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }

  condition {
    host_header {
      values = ["brigajani.website"]
    }
  }
}

# sonar.brigajani.website → sonar
resource "aws_lb_listener_rule" "sonar_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  }

  condition {
    host_header {
      values = ["sonar.brigajani.website"]
    }
  }
}


# nexus.brigajani.website → nexus
resource "aws_lb_listener_rule" "nexus_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 12

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus_tg.arn
  }

  condition {
    host_header {
      values = ["nexus.brigajani.website"]
    }
  }
}
