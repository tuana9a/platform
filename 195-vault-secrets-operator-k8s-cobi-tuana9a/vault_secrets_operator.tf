resource "helm_release" "vault_secrets_operator" {
  name             = "vault-secrets-operator"
  namespace        = "vault-secrets-operator"
  create_namespace = true

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault-secrets-operator"
  version    = "0.9.0"

  values = [file("./values.yaml")]
}
