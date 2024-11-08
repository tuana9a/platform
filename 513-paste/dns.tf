resource "cloudflare_record" "paste" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "paste"
  value   = google_cloud_run_v2_service.paste.uri
  type    = "TXT"
  ttl     = 60
  proxied = false
}