resource "cloudflare_record" "txt_v_spf1" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "@"
  # There cannot be more than one SPF record associated with a domain.
  content = "v=spf1 include:_spf.vhost.vn include:_spf.mailersend.net include:_spf.mx.cloudflare.net include:spf.mandrillapp.com ~all"
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
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "cname_www_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "www"
#   content = cloudflare_record.a_tuana9a_com.hostname
#   type    = "CNAME"
#   ttl     = 60
#   proxied = false
# }

resource "cloudflare_record" "a_mail_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "mail"
  content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}

# resource "cloudflare_record" "a_webmail_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "webmail"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpanel_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpanel"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_autodiscover_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "autodiscover"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpcalendars_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpcalendars"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_cpcontacts_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "cpcontacts"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

# resource "cloudflare_record" "a_webdisk_tuana9a_com" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "webdisk"
#   content = data.vault_kv_secret.vhost_email_hosting_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }

resource "cloudflare_record" "mx_mx_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  content  = "mx.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 5
}

resource "cloudflare_record" "mx_mx1_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  content  = "mx1.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 10
}

resource "cloudflare_record" "mx_mx2_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  content  = "mx2.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 15
}

resource "cloudflare_record" "mx_mx3_vhost_vn" {
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  content  = "mx3.vhost.vn"
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = 20
}

# resource "cloudflare_record" "mx_mail_tuana9a_com" {
#   zone_id  = data.cloudflare_zone.tuana9a_com.id
#   name     = "@"
#   content  = cloudflare_record.a_mail_tuana9a_com.hostname
#   type     = "MX"
#   ttl      = 60
#   proxied  = false
#   priority = 5
# }

resource "cloudflare_record" "txt_default__domain_key" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "default._domainkey"
  content = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyIT85mld5B8eUwMKRARYKtpszDfWlhrGq9nwAj15freOE7jO1GYJzNQkYIS4U0B8y93TWGHRHIAoqnHpd77LTTlcf92wOenu5POOgF1Q9Fe+DrNzyGmrHpAflMDVr7RmpSVNE0P10FFu9F2rejOLSrS1he15hzu0ztI/kr7NLK+q2s/4X5Bz5qagGmIdz7uNW/s+TnQAYA9JsA4YmmF4vLx4K0cEeWlG6pfQ8fmGxHedV10256hiwTx9uUYtzLEih2c1j26sAYfPKFBfZFXrLdsifATdVjrEbPsnJSd8nNoB/TYBTCnnKjULacr20VB6flXo021G5yK1aUctDl5AvQIDAQAB;"
  type    = "TXT"
  ttl     = 60
  proxied = false
}
