# go to aws console and grab the validation information paste here

resource "cloudflare_dns_record" "acm_tuana9a_com_validation" {
  zone_id = data.cloudflare_zone.tuana9a_com.zone_id
  name    = "_f261b95fb13ad0ffdde1f26eb18ec1e7.tuana9a.com."
  ttl     = 3600
  type    = "CNAME"
  comment = "Domain verification record"
  content = "_0c78ab7286ba77a2a449747c2f6a5e81.zzssrbpcnq.acm-validations.aws."
  proxied = false
}
