resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  acl    = "private"
  tags = {
    app = var.app_name
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "s3/"
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

data "aws_iam_policy_document" "website" {
  # website-updater can list files
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.website-updater.arn]
    }
    resources = [aws_s3_bucket.website.arn]
  }
  # website-updater can change files
  statement {
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

  # Cloudfront access list items
  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = [aws_s3_bucket.website.arn]
    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.website.s3_canonical_user_id]
    }
  }
  # Cloudfront access get files
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.website.arn}/*"]
    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.website.s3_canonical_user_id]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}
