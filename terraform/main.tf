
variable "domain_name" {
  type = string
}

variable "upload_user" {
  type = string
}

variable "app_name" {
  type = string
}

variable "region" {
  type = string
}

provider "aws" {
  version = "=2.43.0"
  region  = var.region
}

provider "aws" {
  version = "=2.43.0"
  region  = "us-east-1"
  alias   = "us-east-1"
}

terraform {
  backend "s3" {
    dynamodb_table = "jason-blog-terraform"
    bucket         = "jason-blog-terraform"
    key            = "jason-blog.tfstate"
    region         = "us-east-1"
    encrypt        = false
  }
}

resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  acl    = ""
  tags = {
    app = var.app_name
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    error_document = "404/index.html"
    index_document = "index.html"
    routing_rules = jsonencode(
      [
        {
          Condition = {
            KeyPrefixEquals = "feed.xml"
          }
          Redirect = {
            ReplaceKeyWith = "index.xml"
          }
        },
      ]
    )
  }
}

resource "aws_iam_user" "website-updater" {
  name = var.upload_user
  tags = {
    app = var.app_name
  }
}

data "aws_iam_policy_document" "website" {
  policy_id = "Policy1428871194772"
  # Everyone can view the website
  statement {
    sid = "Stmt1428871192093"
    actions = [
      "s3:GetObject",
    ]
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }

  # website-updater can change files
  statement {
    sid     = "Stmt1491071843579"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.website-updater.arn]
    }
    resources = [aws_s3_bucket.website.arn]
  }

  statement {
    sid    = "Stmt1491071843578"
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.website-updater.arn]
    }
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}

resource "aws_cloudfront_distribution" "website" {
  aliases             = [var.domain_name]
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  tags = {
    app = var.app_name
  }
  wait_for_deployment = true

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 86400
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "S3-Website- ${aws_s3_bucket.website.website_endpoint}"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.website.website_endpoint
    origin_id   = "S3-Website- ${aws_s3_bucket.website.website_endpoint}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.website.id
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }
}

resource "aws_route53_zone" "website" {
  provider = aws.us-east-1
  name     = var.domain_name
  comment  = "Personal blog"
  tags = {
    app = var.app_name
  }
}

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

resource "aws_route53_record" "website-cdn" {
  provider = aws.us-east-1
  zone_id  = aws_route53_zone.website.zone_id
  name     = var.domain_name
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

output "url" {
  value = "https://${aws_route53_record.website-cdn.fqdn}"
}
