resource "cloudflare_email_routing_rule" "tuana9a_tuana9a_com" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "tuana9a@tuana9a.com"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "tuana9a@tuana9a.com"
  }

  action {
    type  = "forward"
    value = ["tuana9a@gmail.com"]
  }
}

resource "cloudflare_email_routing_rule" "admin_tuana9a_com" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "admin@tuana9a.com"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "admin@tuana9a.com"
  }

  action {
    type  = "forward"
    value = ["tuana9a@gmail.com"]
  }
}
