variable "repo_name" {
  type = string
}

variable "repo_secrets" {
  type      = map(any)
  sensitive = true
}
