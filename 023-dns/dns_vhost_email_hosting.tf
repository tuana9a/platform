resource "cloudflare_record" "txt_v_spf1" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "@"
  # There cannot be more than one SPF record associated with a domain.
  value   = "v=spf1 include:_spf.vhost.vn include:_spf.mailersend.net include:_spf.mx.cloudflare.net include:spf.mandrillapp.com ~all"
  type    = "TXT"
  ttl     = 60
  proxied = false
}

data "vault_kv_secret" "vhost_email_hosting_public_ip" {
  path = "kv/public-ip/vhost-email-hosting"
}

# resource "cloudflare_record" "a_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "@"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "cname_www_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "www"
#   value   = cloudflare_record.a_tuana9a_com.hostname
#   type    = "CNAME"
#   ttl     = 60
#   proxied = false
# }

resource "cloudflare_record" "a_mail_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "mail"
  value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}

# resource "cloudflare_record" "a_webmail_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "webmail"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpanel_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpanel"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_autodiscover_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "autodiscover"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpcalendars_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpcalendars"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpcontacts_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpcontacts"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_webdisk_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "webdisk"
#   value   = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

resource "cloudflare_record" "mx_mx_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  value    = "mx.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 5
}

resource "cloudflare_record" "mx_mx1_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  value    = "mx1.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 10
}

resource "cloudflare_record" "mx_mx2_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  value    = "mx2.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 15
}

resource "cloudflare_record" "mx_mx3_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  value    = "mx3.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 20
}

# resource "cloudflare_record" "mx_mail_tuana9a_com" {
#   zone_id  = data.cloudflare_zone.tuana9a_com.id
#   name     = "@"
#   value    = cloudflare_record.a_mail_tuana9a_com.hostname
#   type     = "MX"
#   ttl      = 60
#   proxied  = false
#   priority = 5
# }
