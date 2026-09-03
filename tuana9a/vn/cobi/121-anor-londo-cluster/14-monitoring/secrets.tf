data "vault_kv_secret_v2" "t9stbot_token" {
  mount = "kvv2"
  name  = "telegram/bots/t9stbot"
}
