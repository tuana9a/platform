variable "coder_token" {
  type      = string
  sensitive = true
}

variable "coder_users" {
  type      = map(any)
  sensitive = true
}
