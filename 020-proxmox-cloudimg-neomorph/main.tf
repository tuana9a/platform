resource "proxmox_virtual_environment_file" "ubuntu22-20250725" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "neomorph"

  source_file {
    file_name = "jammy-server-cloudimg-amd64.img"
    path      = "https://cloud-images.ubuntu.com/jammy/20250725/jammy-server-cloudimg-amd64.img"
  }
}

locals {
  debian12_daily_versions = ["20250814-2204", "20251129-2311"]
  pve_nodes = {
    neomorph = {
      debian12_daily_versions = local.debian12_daily_versions
    }
    engineer = {
      debian12_daily_versions = local.debian12_daily_versions
    }
  }
}

module "pve-node-cloudimg" {
  for_each = local.pve_nodes
  source   = "./modules/pve-node-cloudimg"

  pve_node_name           = each.key
  debian12_daily_versions = lookup(each.value, "debian12_daily_versions", [])
}
