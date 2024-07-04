locals {
  proxmox_node = {
    pve_cobi = {
      node_name = "pve-cobi"
      storage = {
        sda = "sda"
        sdb = "sdb"
      }
    }
  }
}
