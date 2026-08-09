resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_jwt_auth_backend" "in_cluster" {
  type                  = "jwt"
  oidc_discovery_url    = "https://192.168.56.21:6443"
  oidc_discovery_ca_pem = base64decode(local.anor_londo_ca_b64)
  path                  = "in-cluster"
  description           = "service account jwt in anor londo cluster"
}
