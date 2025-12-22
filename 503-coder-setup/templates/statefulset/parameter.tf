data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores"
  icon         = "/icon/memory.svg"
  mutable      = true
  default      = "1"
  option {
    name  = "1 Cores"
    value = "1"
  }
  option {
    name  = "2 Cores"
    value = "2"
  }
  option {
    name  = "4 Cores"
    value = "4"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory in GB"
  icon         = "/icon/memory.svg"
  mutable      = true
  default      = "2"
  option {
    name  = "2 GB"
    value = "2"
  }
  option {
    name  = "4 GB"
    value = "4"
  }
  option {
    name  = "6 GB"
    value = "6"
  }
  option {
    name  = "8 GB"
    value = "8"
  }
}

data "coder_parameter" "home_persistent" {
  name         = "home_persistent"
  display_name = "Home dir persistent"
  description  = "Whether home dir is persistent or ephemeral"
  mutable      = true
  type         = "string"
  default      = "no"
  option {
    name  = "yes"
    value = "yes"
  }
  option {
    name  = "no"
    value = "no"
  }
}

data "coder_parameter" "home_disk_size" {
  name         = "home_disk_size"
  display_name = "Home disk size"
  description  = "The size of the home disk in GB"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false
  default      = "10"
  validation {
    min = 5
    max = 100
  }
}

data "coder_parameter" "home_storage_class" {
  name         = "home_storage_class"
  display_name = "Home storage class"
  description  = "home storage class"
  mutable      = false
  type         = "string"
  default      = "proxmox-data-xfs"
  option {
    name  = "proxmox-data-xfs"
    value = "proxmox-data-xfs"
  }
}

data "coder_parameter" "image_tag" {
  name         = "image_tag"
  display_name = "Image tag"
  description  = "Docker image tuana9a/coder tag"
  default      = "base"
  icon         = "/icon/docker.png"
  mutable      = true
}
