variable "namespace" {
  type = string
}

variable "secrets" {
  type = map(map(string))
}
