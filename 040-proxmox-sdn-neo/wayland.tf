resource "proxmox_virtual_environment_sdn_zone_simple" "wayland" {
  id   = "wayland"
  ipam = "pve"
}

resource "proxmox_virtual_environment_sdn_vnet" "vmbr23" {
  id   = "vmbr23"
  zone = proxmox_virtual_environment_sdn_zone_simple.wayland.id
}

resource "proxmox_virtual_environment_sdn_subnet" "vmbr23" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vmbr23.id
  cidr    = "192.168.23.0/24"
  snat    = true
  gateway = "192.168.23.1"
}
