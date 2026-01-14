data "cloudflare_zone" "tuana9a_com" {
  filter = {
    name = "tuana9a.com"
  }
}

resource "cloudflare_dns_record" "tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.zone_id
  name    = "@"
  ttl     = 3600
  type    = "CNAME"
  comment = "CDN for the tuana9a.com"
  content = aws_cloudfront_distribution.tuana9a_com.domain_name
  proxied = false
}
