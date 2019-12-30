resource "aws_cloudwatch_log_group" "ci" {
  name              = var.app_name
  retention_in_days = 30
  tags = {
    app = var.app_name
  }
}

resource "aws_cloudwatch_log_stream" "ci" {
  name           = var.domain_name
  log_group_name = aws_cloudwatch_log_group.ci.name
}


data "aws_iam_policy_document" "ci" {
  # Codebuild logs
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_stream.ci.arn}/*"]
  }

  # Codebuild role permissions
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole",
    ]

    resources = [aws_iam_role.codebuild.arn]
  }

  # list website files
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website.arn]
  }
  # update website files
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_iam_policy" "ci" {
  name   = "${var.app_name}-ci"
  path   = "/"
  policy = data.aws_iam_policy_document.ci.json
}

data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.app_name}-ci"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
  tags = {
    app = var.app_name
  }
}

resource "aws_iam_role_policy_attachment" "codebuild-ci" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.ci.arn
}

resource "aws_codebuild_project" "codebuild" {
  name          = var.app_name
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = "30"
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    privileged_mode = true
  }

  source {
    type                = "GITHUB"
    location            = var.github_source_url
    git_clone_depth     = 1
    buildspec           = "buildspec.yml"
    report_build_status = true
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = var.app_name
      stream_name = var.domain_name
    }
  }

  tags = {
    app = var.app_name
  }
}

resource "aws_codebuild_webhook" "website" {
  project_name = var.app_name

  filter_group {
    filter {
      exclude_matched_pattern = false
      pattern                 = "PUSH"
      type                    = "EVENT"
    }
    filter {
      exclude_matched_pattern = false
      pattern                 = "^refs/heads/master$"
      type                    = "HEAD_REF"
    }
  }
}
