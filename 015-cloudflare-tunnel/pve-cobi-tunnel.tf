# cloudflare tunnel is created manually first (as part of proxmox migration)
data "cloudflare_zero_trust_tunnel_cloudflared" "pve_cobi_tunnel" {
  account_id = local.cloudflare_account_id
  name       = "pve-cobi-tunnel"
}

resource "cloudflare_record" "pve-cobi_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "pve-cobi"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_cobi_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

import {
  id = "${local.cloudflare_account_id}/${data.cloudflare_zero_trust_tunnel_cloudflared.pve_cobi_tunnel.id}"
  to = cloudflare_zero_trust_tunnel_cloudflared_config.pve_cobi_tunnel
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "pve_cobi_tunnel" {
  account_id = local.cloudflare_account_id
  tunnel_id  = data.cloudflare_zero_trust_tunnel_cloudflared.pve_cobi_tunnel.id

  config {
    ingress_rule {
      hostname = cloudflare_record.pve-cobi_tuana9a_com.hostname
      service  = "https://192.168.56.1:8006"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = true
        proxy_port               = 0
      }
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}
