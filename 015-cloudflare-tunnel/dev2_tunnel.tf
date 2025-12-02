resource "random_password" "dev2_tunnel" {
  length  = 32
  special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "dev2_tunnel" {
  account_id    = local.cloudflare_account_id
  name          = "dev2-tunnel"
  config_src    = "cloudflare"
  tunnel_secret = base64encode(random_password.dev2_tunnel.result)
}

resource "cloudflare_dns_record" "c-dev2_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "c-dev2"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.dev2_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "c-neomorph_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "c-neomorph"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.dev2_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "dev2_tunnel" {
  account_id = local.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.dev2_tunnel.id

  config = {
    ingress = [
      {
        hostname = cloudflare_dns_record.c-neomorph_tuana9a_com.name
        service  = "https://192.168.56.112:8006"
        origin_request = {
          bastion_mode             = false
          disable_chunked_encoding = false
          http2_origin             = false
          keep_alive_connections   = 0
          no_happy_eyeballs        = false
          no_tls_verify            = true
          proxy_port               = 0
        }
      },
      {
        hostname = cloudflare_dns_record.c-dev2_tuana9a_com.name
        service  = "http://192.168.56.209:8209"
        origin_request = {
          bastion_mode             = false
          disable_chunked_encoding = false
          http2_origin             = false
          keep_alive_connections   = 0
          no_happy_eyeballs        = false
          no_tls_verify            = false
          proxy_port               = 0
        }
      },
      {
        service = "http_status:503"
      }
    ]
  }
}
