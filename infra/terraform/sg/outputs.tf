output "wordpress_sg" {
  value = aws_security_group.wordpress.id
  description = "wordpress sg"
}

output "lb_sg" {
  value = aws_security_group.load_balancer.id
  description = "lb sg"
}

