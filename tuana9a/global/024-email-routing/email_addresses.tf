resource "cloudflare_email_routing_address" "all" {
  for_each   = local.email_addresses
  account_id = local.cloudflare_account_id
  email      = sensitive(each.value)
}
