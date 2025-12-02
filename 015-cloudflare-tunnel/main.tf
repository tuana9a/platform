locals {
  cloudflare_account_id = var.cloudflare_account_id
}

data "cloudflare_zone" "tuana9a_com" {
  filter = {
    name = "tuana9a.com"
  }
}

resource "cloudflare_zero_trust_access_policy" "allow_everyone" {
  account_id = local.cloudflare_account_id
  name       = "allow-everyone"
  decision   = "allow"

  include = [{
    everyone = {
    }
  }]
}

resource "cloudflare_zero_trust_access_policy" "allow_tuana9a" {
  account_id = local.cloudflare_account_id
  name       = "allow-tuana9a"
  decision   = "allow"

  include = [
    {
      email = {
        email = "tuana9a@gmail.com"
      }
    },
    {
      email_domain = {
        domain = "tuana9a.com"
      }
    }
  ]
}
