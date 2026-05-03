resource "cloudflare_record" "records_v2" {
  for_each = local.records_v2
  zone_id  = data.cloudflare_zone.tuana9a_com.id

  type    = each.value.type
  name    = each.value.name
  content = each.value.content
  ttl     = each.value.ttl
  proxied = each.value.proxied
}
