# wordpress server
resource "aws_instance" "wordpress" {
  ami                    = "ami-0a716d3f3b16d290c" # ubu 24.04
  instance_type          = "t3.micro"
  subnet_id              = var.wordpres_subnet_id[0]
  vpc_security_group_ids = [var.wordpress_sg]
  iam_instance_profile   = var.wordpress_profile
  tags = {
    "Name" = "${var.deployment_prefix}-wordpress-server"
  }
}
