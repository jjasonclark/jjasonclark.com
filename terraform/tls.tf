resource "aws_acm_certificate" "website" {
  provider    = aws.us-east-1
  domain_name = var.domain_name
  tags = {
    app = var.app_name
  }
  validation_method = "EMAIL"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
}
