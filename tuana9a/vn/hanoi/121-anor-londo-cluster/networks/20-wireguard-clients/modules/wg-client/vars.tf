variable "name" {
  type        = string
  description = "Name of the wireguard client"
}

variable "wg_configs" {
  type        = list(string)
  description = "List of wireguard configs. WARN: Order matters"
}

variable "namespace" {
  type        = string
  description = "K8S namespace for the wireguard client"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "wg_image" {
  type    = string
  default = "lscr.io/linuxserver/wireguard:1.0.20250521-r1-ls113"
}
