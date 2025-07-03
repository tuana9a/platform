locals {
  email_addresses = toset(values(nonsensitive(data.vault_kv_secret.tuana9a_com_email_routes.data)))
}

resource "cloudflare_email_routing_address" "all" {
  for_each   = local.email_addresses
  account_id = local.cloudflare_account_id
  email      = each.value
}
