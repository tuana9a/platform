data "vault_kv_secret_v2" "github_token" {
  mount = "kvv2"
  name  = "github.com/tuana9a/_/tokens/actions-runner-controller"
}
