data "coder_parameter" "cpu" {
  name         = "0_cpu"
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
  name         = "1_memory"
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

data "coder_parameter" "home_disk_size" {
  name         = "3_home_disk_size"
  display_name = "Home disk size"
  description  = "The size of the home disk in GB, set to 0 to disable the persistent"
  type         = "number"
  icon         = "/icon/database.svg"
  mutable      = false
  default      = "10"
  validation {
    min = 0
    max = 100
  }
}

data "coder_parameter" "home_disk_storage_class" {
  name         = "4_home_disk_storage_class"
  display_name = "Home disk storage class"
  description  = "The home disk storage class to use"
  icon         = "/icon/database.svg"
  mutable      = false
  type         = "string"
  default      = "proxmox-data-xfs"
  option {
    name  = "proxmox-data-xfs"
    value = "proxmox-data-xfs"
  }
}

data "coder_parameter" "image_tag" {
  name         = "6_image_tag"
  display_name = "Image tag"
  description  = "Docker image tuana9a/coder tag"
  default      = "minimal-2025.12.22"
  icon         = "/icon/docker.png"
  mutable      = true
}
