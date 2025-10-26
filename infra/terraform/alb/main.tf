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

# tg attachment wordpress
resource "aws_lb_target_group_attachment" "wordpress_attach" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = var.wordpress_server
  port             = 80
}
# tg attachment adminer
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

# tg attachment wordpress
resource "aws_lb_target_group_attachment" "adminer_attach" {
  target_group_arn = aws_lb_target_group.adminer_tg.arn
  target_id        = var.wordpress_server
  port             = 8081
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
  name    = "www"
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
  name    = "api"
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
      values = ["www.brigajani.website"]
    }
  }
}

# api.brigajani.website → API
resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.adminer_tg.arn
  }

  condition {
    host_header {
      values = ["api.brigajani.website"]
    }
  }
}