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
