resource "cloudflare_email_routing_rule" "admin_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "admin@tuana9a.com"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "admin@tuana9a.com"
  }

  action {
    type  = "forward"
    value = [cloudflare_email_routing_address.tuana9a_gmail_com.email]
  }
}

resource "cloudflare_email_routing_rule" "zero_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "zero@tuana9a.com"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "zero@tuana9a.com"
  }

  action {
    type  = "forward"
    value = [cloudflare_email_routing_address.tuana9a_gmail_com.email]
  }
}
