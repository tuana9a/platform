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

data "coder_parameter" "home_persistent" {
  name         = "home_persistent"
  display_name = "home_persistent"
  description  = "home dir persistent"
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
  default      = "2"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false
  validation {
    min = 1
    max = 10
  }
}

data "coder_parameter" "image_tag" {
  name         = "image_tag"
  display_name = "Image tag"
  description  = "tuana9a/coder image tag"
  default      = "base"
  icon         = "/icon/docker.png"
  mutable      = true
}

data "coder_parameter" "dockerd" {
  name         = "dockerd"
  display_name = "dockerd"
  description  = "Docker in docker"
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

data "coder_parameter" "dockerd_persistent" {
  name         = "dockerd_persistent"
  display_name = "dockerd_persistent"
  description  = "Docker data persistent"
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
