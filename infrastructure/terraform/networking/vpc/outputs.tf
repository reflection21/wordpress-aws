output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id"
}

output "wordpress_subnet_id" {
  value       = [for s in aws_subnet.wordpress : s.id]
  description = "wordpress subnet id"
}

output "public_subnet_id" {
  value       = [for s in aws_subnet.public : s.id]
  description = "public subnet id"
}

output "rds_subnet_id" {
  value       = [for s in aws_subnet.rds : s.id]
  description = "rds subnet id"
}
