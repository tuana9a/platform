variable "ssh_user" {
  type = string
}

variable "private_key" {
  type      = string
  ephemeral = true
}

variable "node" {
  type = object({
    nodename                 = string
    ip_address               = string
    is_control_plane         = optional(bool, false)
    is_primary_control_plane = optional(bool, false)
    is_the_first_upgrade     = optional(bool, false)
  })
}

variable "primary_control_plane" {
  type = object({
    nodename   = string
    ip_address = string
  })
}

variable "next_version" {
  type = string
}

variable "next_version_channel" {
  type = string
}

variable "triggers_replace" {
  type = string
}
