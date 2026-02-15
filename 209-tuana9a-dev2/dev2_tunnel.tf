locals {
  cloudflare_account_id = var.cloudflare_account_id
}

data "cloudflare_zone" "tuana9a_com" {
  filter = {
    name = "tuana9a.com"
  }
}

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

locals {
  dev2_tunnel_setup_token = base64encode(jsonencode({
    a = local.cloudflare_account_id,
    t = cloudflare_zero_trust_tunnel_cloudflared.dev2_tunnel.id
    s = base64encode(random_password.dev2_tunnel.result)
  }))
}

output "dev2_tunnel_setup" {
  value     = <<-EOT
# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared
sudo cloudflared service install ${local.dev2_tunnel_setup_token}
EOT
  sensitive = true
}
