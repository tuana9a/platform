# import {
#   id = "${data.cloudflare_zone.tuana9a_com.id}/41d0f9574c7d817ba368aa2c3b4cc2af"
#   to = cloudflare_record.dev2_tuana9a_com
# }

import {
  id = "${local.cloudflare_account_id}/${data.cloudflare_zero_trust_tunnel_cloudflared.pve_xeno_tunnel.id}"
  to = cloudflare_zero_trust_tunnel_cloudflared_config.pve_xeno_tunnel
}
