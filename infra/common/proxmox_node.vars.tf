variable "proxmox_node" {
  type = object({
    name          = string
    storage_names = list(object({ name = string }))
  })
}
