resource "aws_acm_certificate" "main" {
  domain_name       = var.domain-name
  validation_method = "DNS"
}

resource "aws_acm_certificate" "subdomains" {
  domain_name       = "*.${var.domain-name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "acm-validation" {
  name    = aws_acm_certificate.main.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options.0.resource_record_type
  zone_id = var.zone.id
  records = [aws_acm_certificate.main.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  depends_on = [aws_route53_record.acm-validation]

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.acm-validation.fqdn]
}

resource "aws_acm_certificate_validation" "subdomains" {
  depends_on = [aws_route53_record.acm-validation]

  certificate_arn         = aws_acm_certificate.subdomains.arn
  validation_record_fqdns = [aws_route53_record.acm-validation.fqdn]
}
