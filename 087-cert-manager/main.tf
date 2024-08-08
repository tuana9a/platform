resource "helm_release" "cert_manager" {
  # https://cert-manager.io/docs/installation/helm/
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.0"

  values = [file("./values.yml")]
}

resource "kubernetes_manifest" "cluster_issuer" {
  depends_on = [helm_release.cert_manager]
  manifest   = yamldecode(file("./manifests/ClusterIssuer.yml"))
}
