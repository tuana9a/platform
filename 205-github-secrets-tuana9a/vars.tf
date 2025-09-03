variable "github_token" {
  type      = string
  sensitive = true
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "secret-operator vault token"
}
