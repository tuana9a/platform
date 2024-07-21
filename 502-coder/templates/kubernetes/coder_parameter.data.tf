data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores"
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "2 Cores"
    value = "2"
  }
  option {
    name  = "4 Cores"
    value = "4"
  }
  option {
    name  = "6 Cores"
    value = "6"
  }
  option {
    name  = "8 Cores"
    value = "8"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory in GB"
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true
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
    max = 100
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
    name  = "tuana9a/coder:adrazaamon-devops"
    value = "tuana9a/coder:adrazaamon-devops"
  }
  option {
    name  = "tuana9a/coder:nodejs"
    value = "tuana9a/coder:nodejs"
  }
  option {
    name  = "tuana9a/coder:java"
    value = "tuana9a/coder:java"
  }
  option {
    name  = "tuana9a/coder:terraform"
    value = "tuana9a/coder:terraform"
  }
  option {
    name  = "tuana9a/coder:go"
    value = "tuana9a/coder:go"
  }
}