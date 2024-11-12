resource "cloudflare_record" "paste_uri" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "paste"
  value   = google_cloud_run_v2_service.paste.uri
  type    = "TXT"
  ttl     = 60
  proxied = false
}

# https://console.cloud.google.com/run/domains
resource "cloudflare_record" "paste" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "paste"
  value   = "ghs.googlehosted.com."
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
