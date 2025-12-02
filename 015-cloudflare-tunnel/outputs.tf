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
