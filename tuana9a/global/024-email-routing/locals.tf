locals {
  secrets = yamldecode(data.external.decrypt_secrets.result.plain_text)

  cloudflare_account_id = local.secrets.cloudflare_account_id

  email_addresses = { for i, x in local.secrets.email_addresses : i => x }

  catch_all_emails_destination = local.secrets.catch_all_emails_destination

  email_routing = {
    for i, route_str in local.secrets.email_routing_v2 : i => {
      forward = split("->", route_str)[0],
      to      = split("->", route_str)[1]
    }
  }
}
