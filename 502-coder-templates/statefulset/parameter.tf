data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores"
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
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
  default      = "1"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "1 GB"
    value = "1"
  }
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
  name         = "home_disk_size"
  display_name = "Home disk size"
  description  = "The size of the home disk in GB"
  default      = "2"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false
  validation {
    min = 1
    max = 10
  }
}

data "coder_parameter" "image" {
  name         = "image"
  display_name = "Image"
  description  = "Docker image"
  default      = "tuana9a/coder:base"
  icon         = "/icon/docker.png"
  mutable      = true
  option {
    name  = "tuana9a/coder:base"
    value = "tuana9a/coder:base"
  }
  option {
    name  = "tuana9a/coder:minimal"
    value = "tuana9a/coder:minimal"
  }
}

data "coder_parameter" "dockerd" {
  name         = "dockerd"
  display_name = "dockerd"
  description  = "Docker Daemon"
  mutable      = true
  type         = "string"
  default      = "false"
  option {
    name  = "true"
    value = "true"
  }
  option {
    name  = "false"
    value = "false"
  }
}

locals {
  coder_parameter = {
    dockerd = data.coder_parameter.dockerd.value == "true" ? [1] : []
  }
}
