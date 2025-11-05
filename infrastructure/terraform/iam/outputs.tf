output "wordpress_profile" {
  value       = aws_iam_instance_profile.wordpress_profile.id
  description = "wordpress provile"
}
