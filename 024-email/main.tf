locals {
  cloudflare_account_id = var.cloudflare_account_id
  email_addresses       = toset(values(nonsensitive(var.email_routes)))
}

data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

resource "cloudflare_email_routing_address" "all" {
  for_each   = local.email_addresses
  account_id = local.cloudflare_account_id
  email      = each.value
}

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

resource "cloudflare_email_routing_rule" "tuana9a_com" {
  for_each = nonsensitive(var.email_routes)
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
