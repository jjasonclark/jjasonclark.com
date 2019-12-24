resource "aws_iam_user" "website-updater" {
  name = var.upload_user
  tags = {
    app = var.app_name
  }
}
