resource "proxmox_virtual_environment_file" "ubuntu_22_jammy_qcow2_img" {
  content_type = "iso"
  datastore_id = var.proxmox_node.storage_names[0].name
  node_name    = var.proxmox_node.name

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}
