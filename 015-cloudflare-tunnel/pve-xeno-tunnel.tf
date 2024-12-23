# cloudflare tunnel is created manually first (as part of proxmox migration)
data "cloudflare_zero_trust_tunnel_cloudflared" "pve_xeno_tunnel" {
  account_id = local.cloudflare_account_id
  name       = "pve-xeno-tunnel"
}

import {
  id = "${data.cloudflare_zone.tuana9a_com.id}/41d0f9574c7d817ba368aa2c3b4cc2af"
  to = cloudflare_record.dev2_tuana9a_com
}

resource "cloudflare_record" "dev2_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "dev2"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "dev2-8000_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "dev2-8000"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "ssh-dev2_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "ssh-dev2"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "lucas-dev_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "lucas-dev"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "lucas-dev-8000_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "lucas-dev-8000"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "amon-dev_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "amon-dev"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "amon-dev-8000_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "amon-dev-8000"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "pve-xeno_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "pve-xeno"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

import {
  id = "${local.cloudflare_account_id}/${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}"
  to = cloudflare_zero_trust_tunnel_cloudflared_config.pve_xeno_tunnel
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "pve_xeno_tunnel" {
  account_id = local.cloudflare_account_id
  tunnel_id  = data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id

  config {
    warp_routing {
      enabled = true
    }
    ingress_rule {
      hostname = cloudflare_record.pve-xeno_tuana9a_com.hostname
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
      hostname = cloudflare_record.dev2_tuana9a_com.hostname
      service  = "http://192.168.56.209:8209"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.dev2-8000_tuana9a_com.hostname
      service  = "http://192.168.56.209:8000"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.ssh-dev2_tuana9a_com.hostname
      service  = "ssh://192.168.56.209:22"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.lucas-dev_tuana9a_com.hostname
      service  = "http://192.168.56.49:8049"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.lucas-dev-8000_tuana9a_com.hostname
      service  = "http://192.168.56.49:8000"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.amon-dev_tuana9a_com.hostname
      service  = "http://192.168.56.206:8206"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      hostname = cloudflare_record.amon-dev-8000_tuana9a_com.hostname
      service  = "http://192.168.56.206:8000"
      origin_request {
        bastion_mode             = false
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 0
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_port               = 0
      }
    }
    ingress_rule {
      service = "http_status:503"
    }
  }
}
