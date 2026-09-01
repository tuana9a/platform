module "k8s-cobi-clients" {
  source    = "./modules/wg-client"
  name      = "k8s-cobi"
  namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
  wg_configs = [
    data.vault_kv_secret_v2.wireguard_clients.data["k8s-cobi-5.conf"],
    data.vault_kv_secret_v2.wireguard_clients.data["k8s-cobi-6.conf"],
    data.vault_kv_secret_v2.wireguard_clients.data["k8s-cobi-7.conf"],
  ]
  replicas = 3
}
