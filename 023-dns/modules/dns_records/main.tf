resource "cloudflare_record" "records" {
  for_each = { for i, x in var.records : i => x }
  zone_id  = var.zone_id
  name     = var.name
  content  = sensitive(each.value.content)
  type     = lookup(each.value, "type", "A")
  ttl      = lookup(each.value, "ttl", 60)
  proxied  = lookup(each.value, "proxied", false)
  comment = "${timestamp()} terraform://023-dns"
}
