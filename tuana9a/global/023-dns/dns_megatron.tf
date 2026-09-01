# resource "cloudflare_record" "megatron" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id

#   name    = "megatron"
#   type    = "A"
#   content = data.bizflycloud_server.megatron.wan_ipv4
#   ttl     = 60
#   proxied = false
# }
