output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "alb name"
}

output "alb_zone_id" {
  value       = aws_lb.alb.zone_id
  description = "zone id "
}
