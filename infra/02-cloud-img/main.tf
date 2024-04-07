resource "proxmox_virtual_environment_file" "ubuntu_22_jammy_qcow2_img" {
  content_type = "iso"
  datastore_id = local.storage_name
  node_name    = local.node_name

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}
