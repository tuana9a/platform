variable "pve_node_name" {
  type = string
}

variable "debian12_daily_versions" {
  type    = list(string)
  default = []
}

variable "ubuntu22_daily_versions" {
  type    = list(string)
  default = []
}
