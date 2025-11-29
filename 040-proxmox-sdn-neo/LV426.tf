# https://avp.fandom.com/wiki/Acheron_(LV-426)
resource "proxmox_virtual_environment_sdn_zone_vxlan" "LV426" {
  id    = "LV426"
  peers = ["192.168.56.112", "192.168.56.113"]
  ipam  = "pve"
}

resource "proxmox_virtual_environment_sdn_vnet" "vmbr34" {
  id   = "vmbr34"
  zone = proxmox_virtual_environment_sdn_zone_vxlan.LV426.id
  tag  = 34
}
