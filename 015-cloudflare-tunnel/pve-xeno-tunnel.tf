# cloudflare tunnel is created manually first (as part of proxmox migration)
data "cloudflare_zero_trust_tunnel_cloudflared" "pve_xeno_tunnel" {
  account_id = local.cloudflare_account_id
  name       = "pve-xeno-tunnel"
}

# resource "cloudflare_record" "dev2_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "dev2"
#   content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
# }

# resource "cloudflare_record" "amon_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "amon"
#   content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
# }

# resource "cloudflare_record" "pve-xeno_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "pve-xeno"
#   content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
# }

resource "cloudflare_record" "ssh-dev2_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "ssh-dev2"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

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

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "pve_xeno_tunnel" {
  account_id = local.cloudflare_account_id
  tunnel_id  = data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id

  config {
    warp_routing {
      enabled = true
    }
    # ingress_rule {
    #   hostname = cloudflare_record.pve-xeno_tuana9a_com.hostname
    #   service  = "https://192.168.56.1:8006"
    #   origin_request {
    #     bastion_mode             = false
    #     disable_chunked_encoding = false
    #     http2_origin             = false
    #     keep_alive_connections   = 0
    #     no_happy_eyeballs        = false
    #     no_tls_verify            = true
    #     proxy_port               = 0
    #   }
    # }
    # ingress_rule {
    #   hostname = cloudflare_record.dev2_tuana9a_com.hostname
    #   service  = "http://192.168.56.209:8209"
    #   origin_request {
    #     bastion_mode             = false
    #     disable_chunked_encoding = false
    #     http2_origin             = false
    #     keep_alive_connections   = 0
    #     no_happy_eyeballs        = false
    #     no_tls_verify            = false
    #     proxy_port               = 0
    #   }
    # }
    # ingress_rule {
    #   hostname = cloudflare_record.ssh-dev2_tuana9a_com.hostname
    #   service  = "ssh://192.168.56.209:22"
    #   origin_request {
    #     bastion_mode             = false
    #     disable_chunked_encoding = false
    #     http2_origin             = false
    #     keep_alive_connections   = 0
    #     no_happy_eyeballs        = false
    #     no_tls_verify            = false
    #     proxy_port               = 0
    #   }
    # }
    # ingress_rule {
    #   hostname = cloudflare_record.amon_tuana9a_com.hostname
    #   service  = "http://192.168.56.206:8206"
    #   origin_request {
    #     bastion_mode             = false
    #     disable_chunked_encoding = false
    #     http2_origin             = false
    #     keep_alive_connections   = 0
    #     no_happy_eyeballs        = false
    #     no_tls_verify            = false
    #     proxy_port               = 0
    #   }
    # }
    ingress_rule {
      service = "http_status:503"
    }
  }
}
