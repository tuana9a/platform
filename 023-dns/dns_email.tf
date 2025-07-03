resource "cloudflare_record" "txt_v_spf1" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "@"
  # There cannot be more than one SPF record associated with a domain.
  content = "v=spf1 include:_spf.vhost.vn include:_spf.mailersend.net include:_spf.mx.cloudflare.net include:spf.mandrillapp.com ~all"
  type    = "TXT"
  ttl     = 60
  proxied = false
}