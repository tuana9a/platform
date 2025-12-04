variable "pve_insecure" {
  type = string
}

variable "pve_endpoint" {
  type = string
}

variable "pve_api_token" {
  type      = string
  sensitive = true
}

variable "pve_username" {
  type      = string
  sensitive = true
}

variable "pve_token_name" {
  type      = string
  sensitive = true
}

variable "pve_token_value" {
  type      = string
  sensitive = true
}

variable "pve_ssh_username" {
  type      = string
  sensitive = true
  default   = "root"
}

variable "pve_ssh_node_name" {
  type      = string
  sensitive = false
}

variable "pve_ssh_node_ip" {
  type      = string
  sensitive = true
}

variable "pve_ssh_private_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "vm_authorized_keys" {
  type      = list(string)
  sensitive = false
  default   = []
}
