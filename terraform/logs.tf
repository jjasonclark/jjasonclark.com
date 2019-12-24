resource "aws_s3_bucket" "logs" {
  provider = aws.us-east-1
  bucket   = "${var.domain_name}-logs"
  acl      = "log-delivery-write"
  tags = {
    app = var.app_name
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  lifecycle_rule {
    id      = "cdn-logs"
    prefix  = "cloudfront"
    enabled = true

    expiration {
      days = 30
    }
  }
}
