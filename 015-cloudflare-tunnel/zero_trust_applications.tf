resource "cloudflare_zero_trust_access_application" "ssh-dev2" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "ssh-dev2"
  domain  = cloudflare_record.ssh-dev2_tuana9a_com.hostname
  type    = "ssh"

  session_duration = "24h"

  auto_redirect_to_identity = false

  policies = [
    cloudflare_zero_trust_access_policy.allow_tuana9a.id,
  ]
}
