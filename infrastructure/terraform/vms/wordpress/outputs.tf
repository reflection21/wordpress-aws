output "wordpress_server_id" {
  value       = aws_instance.wordpress.id
  description = "wordpress server"
}
