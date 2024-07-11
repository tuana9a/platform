resource "cloudflare_record" "argocd" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "argocd"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "argocd_grpc" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "grpc.argocd"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
