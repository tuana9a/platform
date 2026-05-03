resource "cloudflare_email_routing_rule" "tuana9a_com" {
  for_each = local.email_routing
  zone_id  = data.cloudflare_zone.tuana9a_com.id

  name    = sensitive(each.value.forward)
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = sensitive(each.value.forward)
  }

  action {
    type  = "forward"
    value = [sensitive(each.value.to)]
  }
}

resource "cloudflare_email_routing_catch_all" "tuana9a_com_default" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "default"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "forward"
    value = [sensitive(local.catch_all_emails_destination)]
  }
}
