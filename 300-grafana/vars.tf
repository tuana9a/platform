variable "cluster_ca_certificate_b64" {
  type      = string
  sensitive = true
}

# k8s service account token
variable "token" {
  type      = string
  sensitive = true
}