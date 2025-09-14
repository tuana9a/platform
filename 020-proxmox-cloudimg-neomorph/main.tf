resource "proxmox_virtual_environment_file" "ubuntu22-20250725" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "neomorph"

  source_file {
    file_name = "jammy-server-cloudimg-amd64.img"
    path      = "https://cloud-images.ubuntu.com/jammy/20250725/jammy-server-cloudimg-amd64.img"
  }
}

resource "proxmox_virtual_environment_file" "debian12-20250814-2204" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "neomorph"

  source_file {
    file_name = "debian-12-generic-amd64-20250814-2204.img"
    path      = "https://cloud.debian.org/images/cloud/bookworm/20250814-2204/debian-12-generic-amd64-20250814-2204.qcow2"
  }
}
