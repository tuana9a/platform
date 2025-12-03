resource "proxmox_virtual_environment_file" "ubuntu22_daily" {
  for_each = { for v in var.daily_versions : v => v }

  content_type = "iso"
  datastore_id = var.pve_datastore_id
  node_name    = var.pve_node_name

  source_file {
    file_name = "jammy-server-cloudimg-amd64-${each.key}.img"
    path      = "https://cloud-images.ubuntu.com/jammy/${each.key}/jammy-server-cloudimg-amd64.img"
  }
}
