locals {
  apps = {
    "argocd.tuana9a.com"           = var.xenomorph_ip
    "*.coder.tuana9a.com"          = var.xenomorph_ip
    "coder.tuana9a.com"            = var.xenomorph_ip
    "d9stbot.tuana9a.com"          = var.xenomorph_ip
    "*.dev2.tuana9a.com"           = var.xenomorph_ip
    "dev2.tuana9a.com"             = var.xenomorph_ip
    "dkhptd-api.tuana9a.com"       = var.xenomorph_ip
    "grafana.tuana9a.com"          = var.xenomorph_ip
    "hcr.tuana9a.com"              = var.xenomorph_ip
    "jenkins.tuana9a.com"          = var.xenomorph_ip
    "paste.default.kn.tuana9a.com" = var.xenomorph_ip
    "paste.stuffs.kn.tuana9a.com"  = var.xenomorph_ip
    "paste.tuana9a.com"            = var.xenomorph_ip
    "pve-xeno.tuana9a.com"         = var.xenomorph_ip
    "t9stbot.tuana9a.com"          = var.xenomorph_ip
    "uuid.stuffs.kn.tuana9a.com"   = var.xenomorph_ip
    "vault.tuana9a.com"            = var.xenomorph_ip
    "ryuu.tuana9a.com"             = var.xenomorph_ip
  }
}

resource "cloudflare_record" "apps" {
  for_each = local.apps
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = each.key
  content  = each.value
  type     = "A"
  ttl      = 60
  proxied  = false
}
