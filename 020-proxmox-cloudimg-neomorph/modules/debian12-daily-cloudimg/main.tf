resource "proxmox_virtual_environment_file" "debian12_daily" {
  for_each = { for v in var.daily_versions : v => v }

  content_type = "iso"
  datastore_id = var.pve_datastore_id
  node_name    = var.pve_node_name

  source_file {
    file_name = "debian-12-generic-amd64-${each.key}.img"
    path      = "https://cloud.debian.org/images/cloud/bookworm/daily/${each.key}/debian-12-generic-amd64-daily-${each.key}.qcow2"
  }
}
