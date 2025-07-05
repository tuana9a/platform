# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/uptime_check

locals {
  checks = {
    hcr_tuana9a_com = {
      name   = "hcr.tuana9a.com"
      type   = "https"
      target = "https://hcr.tuana9a.com"
    }
    dkhptd-api_tuana9a_com = {
      name   = "dkhptd-api.tuana9a.com"
      type   = "https"
      target = "https://dkhptd-api.tuana9a.com"
    }
    coder_tuana9a_com = {
      name    = "coder.tuana9a.com"
      type    = "https"
      target  = "https://coder.tuana9a.com"
      regions = ["eu_west", "se_asia"]
    }
    xenomorph_tuana9a_com = {
      name   = "xenomorph.tuana9a.com"
      type   = "ping"
      target = "xenomorph.tuana9a.com"
    }
  }
}

resource "digitalocean_uptime_check" "all" {
  for_each = local.checks
  type     = each.value.type
  name     = each.value.name
  target   = each.value.target
  regions  = lookup(each.value, "regions", ["se_asia"])
}
