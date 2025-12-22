variable "pve_insecure" {
  type = bool
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

variable "proxmox_csi_pve_url" {
  type      = string
  sensitive = true
}

variable "proxmox_csi_cluster_name" {
  type = string
}

variable "proxmox_csi_pve_insecure" {
  type = bool
}

variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}
