resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_name}-logs"
  acl    = "log-delivery-write"
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

  lifecycle_rule {
    id      = "s3-logs"
    prefix  = "s3"
    enabled = true

    expiration {
      days = 30
    }
  }
}
