resource "kubernetes_secret_v1" "coder_db_url" {
  metadata {
    name      = "coder-db-url"
    namespace = var.namespace
  }

  data = {
    url = var.coder_db_url
  }
}

resource "helm_release" "coder" {
  name             = "coder"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://helm.coder.com/v2"
  chart      = "coder"
  version    = "2.10.1"

  values = [
    "${file("./values.yaml")}"
  ]

  depends_on = [kubernetes_secret_v1.coder_db_url]
}
