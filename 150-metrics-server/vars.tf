variable "cluster_ca_certificate_b64" {
  type      = string
  sensitive = true
}

variable "client_certificate_b64" {
  type      = string
  sensitive = true
}

variable "client_key_b64" {
  type      = string
  sensitive = true
}
