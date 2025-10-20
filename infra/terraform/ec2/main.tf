# wordpress server
resource "aws_instance" "wordpress" {
  ami                    = "ami-0a716d3f3b16d290c"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.wordpress_sg]
  iam_instance_profile   = var.wordpress_profile
  tags = {
    "Name" = "${var.deployment_prefix}-wordpress-server"
  }
}
