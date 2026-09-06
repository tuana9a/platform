locals {
  cloudimgs = [
    { source_file = { path = "https://cloud.debian.org/images/cloud/bookworm/20260510-2474/debian-12-generic-amd64-20260510-2474.qcow2" } },
    { source_file = { path = "https://cloud-images.ubuntu.com/noble/20260615/noble-server-cloudimg-amd64.img" } }
  ]
}

resource "proxmox_virtual_environment_file" "neomorph" {
  for_each = { for i, v in local.cloudimgs : i => v }

  content_type = lookup(each.value, "content_type", "iso")
  datastore_id = lookup(each.value, "datastore_id", "local")
  node_name    = "neomorph"

  source_file {
    file_name = lookup(each.value, "file_name", "${split(".", basename(each.value.source_file.path))[0]}.img")
    path      = each.value.source_file.path
  }
}

resource "proxmox_virtual_environment_file" "engineer" {
  for_each = { for i, v in local.cloudimgs : i => v }

  content_type = lookup(each.value, "content_type", "iso")
  datastore_id = lookup(each.value, "datastore_id", "local")
  node_name    = "engineer"

  source_file {
    file_name = lookup(each.value, "file_name", "${split(".", basename(each.value.source_file.path))[0]}.img")
    path      = each.value.source_file.path
  }
}
