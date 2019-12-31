output "nameservers" {
  value = aws_route53_zone.website.name_servers
}

output "s3-url" {
  value = "http://${aws_s3_bucket.website.website_endpoint}"
}

output "cdn-url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "url" {
  value = "https://${aws_route53_record.website-cdn.fqdn}"
}

output "build-badge" {
  value = aws_codebuild_project.codebuild.badge_url
}
