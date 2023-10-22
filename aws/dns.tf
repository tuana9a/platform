resource "cloudflare_record" "zion" {
  zone_id = var.cloudflare_zone_id
  name    = "zion"
  value   = aws_eip.zion.public_ip
  type    = "A"
  ttl     = 86400
  proxied = false
}
