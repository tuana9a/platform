resource "proxmox_virtual_environment_file" "jammy_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "xenomorph"

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}
