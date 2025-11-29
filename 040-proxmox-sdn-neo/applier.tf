resource "proxmox_virtual_environment_sdn_applier" "all" {
  depends_on = [
    proxmox_virtual_environment_sdn_zone_simple.wayland,
    proxmox_virtual_environment_sdn_vnet.vmbr23,
    proxmox_virtual_environment_sdn_zone_vxlan.LV426,
    proxmox_virtual_environment_sdn_vnet.vmbr34,
  ]
}
