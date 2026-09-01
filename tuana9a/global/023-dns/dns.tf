locals {
  raw_records_v2 = yamldecode(templatefile("./dns.yml", {
    imperial_ally_285602_ip = data.vault_kv_secret_v2.dns.data.imperial_ally_285602_ip,
    megatron_ip             = data.vault_kv_secret_v2.dns.data.megatron_ip,
    orisis_ip               = data.vault_kv_secret_v2.dns.data.orisis_ip,
  }))
  records_v2 = {
    for i, v in flatten([
      for record_type, domains in local.raw_records_v2 : [
        for domain_name, values in domains : [
          for idx, value in values : {
            key     = "${record_type}_${domain_name}_${idx}"
            type    = record_type
            name    = domain_name
            content = value.content
            ttl     = lookup(value, "ttl", 60)
            proxied = lookup(value, "proxied", false)
            comment = lookup(value, "comment", "${record_type}_${domain_name}_${idx}")
          }
        ]
      ]
    ]) : v.key => v
  }
}

resource "cloudflare_record" "records_v2" {
  for_each = nonsensitive(local.records_v2)

  zone_id = data.cloudflare_zone.tuana9a_com.id
  type    = each.value.type
  name    = each.value.name
  content = each.value.content
  ttl     = each.value.ttl
  proxied = each.value.proxied
}
