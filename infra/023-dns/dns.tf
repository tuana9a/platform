resource "cloudflare_record" "zephyrus" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zephyrus"
  value   = "1.1.1.1" # placeholder value only
  type    = "A"
  ttl     = 60
  proxied = false
  lifecycle {
    ignore_changes = [value]
  }
}

resource "cloudflare_record" "zpr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zpr"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "orisis" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "orisis"
  value   = "1.1.1.1" # placeholder value only
  type    = "A"
  ttl     = 60
  proxied = false
  lifecycle {
    ignore_changes = [value]
  }
}

resource "cloudflare_record" "ors" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "ors"
  value   = cloudflare_record.orisis.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = "1.1.1.1" # placeholder value only
  type    = "A"
  ttl     = 60
  proxied = false
  lifecycle {
    ignore_changes = [value]
  }
}

resource "cloudflare_record" "dkhptd_api" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-api"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "dkhptd_api_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-api-dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "grafana"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "hcr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "hcr"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "hust_captcha_resolver" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "hust-captcha-resolver"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "t9stbot_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot-dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "t9stbot" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "test" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "test"
  value   = "1.1.1.1"
  type    = "A"
  ttl     = 1
  proxied = false
  lifecycle {
    ignore_changes = [value]
  }
}

resource "cloudflare_record" "backend_facebook_clone" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "backend-facebook-clone"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "wg_zpr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "wg-zpr"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "coder" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "coder"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "pve_cobi" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "pve-cobi"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
