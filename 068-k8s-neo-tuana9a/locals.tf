locals {
  vm_list = {
    134 = {
      vmid           = 134
      corecount      = 8
      memsize        = 16384
      disksize       = 50
      vmip           = "192.168.56.34"
      address        = "192.168.56.34/24"
      gateway_ip     = "192.168.56.1"
      network_device = "vmbr56"
    }
  }
}
