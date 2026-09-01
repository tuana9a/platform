# module "starscream" {
#   source    = "./modules/wg-client"
#   name      = "starscream"
#   namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
#   wg_configs = [
#     data.vault_kv_secret_v2.wireguard_clients.data.starscream-0_conf,
#     data.vault_kv_secret_v2.wireguard_clients.data.starscream-1_conf,
#     data.vault_kv_secret_v2.wireguard_clients.data.starscream-2_conf,
#   ]
#   replicas = 2
# }
