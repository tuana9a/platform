resource "cloudflare_record" "dkhptd_api" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-api"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "dkhptd_api_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-api-dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "hcr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "hcr"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
