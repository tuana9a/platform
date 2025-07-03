resource "cloudflare_record" "OSSRH_88779" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "@"
  content = "OSSRH-88779"
  type    = "TXT"
  ttl     = 60
  proxied = false
}
