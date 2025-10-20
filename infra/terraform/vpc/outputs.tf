output "private_subnet_id" {
  value       = aws_subnet.private.id
  description = "private subnet id"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = [for s in aws_subnet.public : s.id]
  description = "private subnet id"
}
