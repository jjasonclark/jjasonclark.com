resource "aws_route53_zone" "website" {
  provider = aws.us-east-1
  name     = var.domain_name
  comment  = "Personal blog"
  tags = {
    app = var.app_name
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

