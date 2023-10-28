resource "cloudflare_record" "api_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "api-dev"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "api" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "api"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "backend_facebook_clone" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "backend-facebook-clone"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dkhptd_api" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-api"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dkhptd_dev_api" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dkhptd-dev-api"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "grafana"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "hcr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "hcr"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "horuss" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "horuss"
  value   = local.horuss_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "http_server" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "http-server"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "hust_captcha_resolver" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "hust-captcha-resolver"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = local.imperial_ally_285602_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "jenkins" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "jenkins"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "nexus" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "nexus"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "orisis" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "orisis"
  value   = local.orisis_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "registry2" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "registry2"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "registry" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "registry"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "t9stbot_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot-dev"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "t9stbot" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "test" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "test"
  value   = local.test_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "zephyrus" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zephyrus"
  value   = local.zephyrus_ip
  type    = "A"
  ttl     = 1
  proxied = false
}
