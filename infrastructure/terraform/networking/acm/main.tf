# ssl cert
resource "aws_acm_certificate" "cert" {
  domain_name               = "brigajani.website"
  validation_method         = "DNS"
  subject_alternative_names = ["sonar.brigajani.website", "nexus.brigajani.website"]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.deployment_prefix}-tls-cert"
  }
}
# validate cert
resource "aws_route53_record" "validate_cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# wait for issued cert
resource "aws_acm_certificate_validation" "cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validate_cert : record.fqdn]

  depends_on = [aws_route53_record.validate_cert]
}
