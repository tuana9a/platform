resource "cloudflare_email_routing_catch_all" "tuana9a_com_default" {
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

data "vault_kv_secret" "tuana9a_com_email_routes" {
  path = "kv/cloudflare/tuana9a.com/email-routes"
}

resource "cloudflare_email_routing_rule" "tuana9a_com" {
  for_each = nonsensitive(data.vault_kv_secret.tuana9a_com_email_routes.data)
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = each.key
  enabled  = true

  matcher {
    type  = "literal"
    field = "to"
    value = each.key
  }

  action {
    type  = "forward"
    value = [each.value]
  }
}
