output "url" {
  value = "https://${aws_route53_record.website-cdn.fqdn}"
}

output "nameservers" {
  value = aws_route53_zone.website.name_servers
}
