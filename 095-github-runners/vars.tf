# Next, Generate a Personal Access Token (PAT) for ARC to authenticate with GitHub.

# Login to your GitHub account and Navigate to "Create new Token."
# Select repo.
# Click Generate Token and then copy the token locally ( we’ll need it later).

variable "github_token" {
  type      = string
  sensitive = true
}

variable "cluster_ca_certificate_b64" {
  type      = string
  sensitive = true
}

variable "token" {
  type      = string
  sensitive = true
}
