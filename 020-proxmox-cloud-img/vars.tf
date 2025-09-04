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
