resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  acl    = "public-read"
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
  # Public read access
  statement {
    actions = ["s3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}
