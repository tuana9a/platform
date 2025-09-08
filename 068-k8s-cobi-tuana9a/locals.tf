locals {
  template_vm_id = 1002
  vm_list_imported = {
    122 = {
      vmid      = 122
      vmip      = "192.168.56.22"
      corecount = 2
      memsize   = 4096
      disksize  = 20

      template_vm_id = 1002
    }
    126 = {
      vmid      = 126
      vmip      = "192.168.56.26"
      corecount = 4
      memsize   = 8192

      template_vm_id = 1002
    }
    128 = {
      vmid      = 128
      vmip      = "192.168.56.28"
      corecount = 4
      memsize   = 8192

      template_vm_id = 1002
    }
    129 = {
      vmid      = 129
      vmip      = "192.168.56.29"
      corecount = 4
      memsize   = 8192

      template_vm_id = 1002
    }
    130 = {
      vmid      = 130
      vmip      = "192.168.56.30"
      corecount = 4
      memsize   = 8192

      template_vm_id = 1002
    }
  }
}