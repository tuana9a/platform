resource "proxmox_virtual_environment_file" "jammy_iso" {
  content_type = "iso"
  datastore_id = local.proxmox_node.pve_cobi.storage.local
  node_name    = local.proxmox_node.pve_cobi.node_name

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}
