variable "pve_node_name" {
  type = string
}

variable "pve_datastore_id" {
  type    = string
  default = "local"
}

variable "daily_versions" {
  type        = list(string)
  description = <<-EOT
example: ["20251129-2311","20250814-2204"]
EOT
}
