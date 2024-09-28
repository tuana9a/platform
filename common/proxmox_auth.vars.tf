variable "pve_endpoint" {
  type = string
}

variable "pve_api_token" {
  type = string
}

variable "pve_ssh_agent_username" {
  type    = string
  default = "root"
}

variable "pve_ssh_agent_private_key_file" {
  type    = string
  default = ""
}
