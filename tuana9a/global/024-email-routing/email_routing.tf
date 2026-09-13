locals {
  preferences     = data.vault_kv_secret_v2.email_routing_preferences.data
  email_addresses = { for i, x in split(";", local.preferences.email_addresses) : i => x }

  catch_all_emails_destination = local.preferences.catch_all_emails_destination

  email_routings = { for i, x in [for k, v in data.vault_kv_secret_v2.email_routings.data : { to : k, forward : v }] : i => x }
}

resource "cloudflare_email_routing_address" "all" {
  for_each   = nonsensitive(toset(keys(local.email_addresses)))
  account_id = local.cloudflare_account_id
  email      = sensitive(local.email_addresses[each.key])
}

resource "cloudflare_email_routing_rule" "tuana9a_com" {
  for_each = nonsensitive(toset(keys(local.email_routings)))

  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = sensitive(local.email_routings[each.key].to)
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = sensitive(local.email_routings[each.key].to)
  }

  action {
    type  = "forward"
    value = [sensitive(local.email_routings[each.key].forward)]
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
