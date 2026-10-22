variable "content" {
  description = "Content of wireguard client config"
  type        = string
}

locals {
  wg_config_raw = var.content

  # Extract the value after "Address = " e.g. "10.20.26.10/24"
  wg_address_cidr = regex("Address\\s*=\\s*(\\S+)", local.wg_config_raw)[0]

  # Normalize to network base, then pick host .1 as gateway
  wg_gateway = cidrhost(cidrsubnet(local.wg_address_cidr, 0, 0), 1)
}

output "wg_address" {
  value = local.wg_address_cidr
}

output "wg_gateway" {
  value = local.wg_gateway
}