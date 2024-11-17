moved {
  from = cloudflare_email_routing_catch_all.drop
  to   = cloudflare_email_routing_catch_all.default
}

resource "cloudflare_email_routing_catch_all" "default" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "default"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "drop"
    value = []
  }
}
