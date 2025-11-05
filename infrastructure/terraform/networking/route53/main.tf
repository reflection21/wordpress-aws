data "aws_route53_zone" "my_zone" {
  name         = var.domain_name
  private_zone = false
}
