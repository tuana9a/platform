resource "proxmox_virtual_environment_file" "debian12-20250814-2204" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "engineer"

  source_file {
    file_name = "debian-12-generic-amd64-20250814-2204.img"
    path      = "https://cloud.debian.org/images/cloud/bookworm/20250814-2204/debian-12-generic-amd64-20250814-2204.qcow2"
  }
}
