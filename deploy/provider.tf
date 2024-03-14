provider "argocd" {
  server_addr = "localhost:8443"
  username    = local.username
  password    = local.password
  insecure    = true
}
