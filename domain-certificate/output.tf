output "certificates" {
  value = {
    main       = aws_acm_certificate.main
    subdomains = aws_acm_certificate.subdomains
  }
}

output "validations" {
  value = {
    main       = aws_acm_certificate_validation.main
    subdomains = aws_acm_certificate_validation.subdomains
  }
}

output "main-certificate" {
  value = {
    acm        = aws_acm_certificate.main
    validation = aws_acm_certificate_validation.main
  }
}

output "subdomains-certificate" {
  value = {
    acm        = aws_acm_certificate.subdomains
    validation = aws_acm_certificate_validation.subdomains
  }
}
