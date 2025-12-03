module "debian12_daily" {
  source         = "../debian12-daily-cloudimg"
  daily_versions = var.debian12_daily_versions
  pve_node_name  = var.pve_node_name
}

# TODO other type of cloud images will go here
module "ubuntu22_daily" {
  source         = "../ubuntu22-daily-cloudimg"
  daily_versions = var.ubuntu22_daily_versions
  pve_node_name  = var.pve_node_name
}
