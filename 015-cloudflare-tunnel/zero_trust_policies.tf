resource "cloudflare_zero_trust_access_policy" "allow_everyone" {
  account_id = local.cloudflare_account_id
  name       = "allow-everyone"
  decision   = "allow"

  include {
    everyone = true
  }
}

resource "cloudflare_zero_trust_access_policy" "allow_tuana9a" {
  account_id = local.cloudflare_account_id
  name       = "allow-tuana9a"
  decision   = "allow"

  include {
    email        = ["tuana9a@gmail.com"]
    email_domain = ["tuana9a.com"]
  }
}
