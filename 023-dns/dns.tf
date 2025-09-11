resource "cloudflare_record" "OSSRH_88779" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "@"
  content = "OSSRH-88779"
  type    = "TXT"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "servers" {
  for_each = local.servers
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = each.key
  content  = sensitive(each.value.ip)
  type     = "A"
  ttl      = 60
  proxied  = false
}

resource "cloudflare_record" "apps" {
  for_each = local.apps
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = each.key
  content  = sensitive(each.value)
  type     = "A"
  ttl      = 60
  proxied  = false
}
