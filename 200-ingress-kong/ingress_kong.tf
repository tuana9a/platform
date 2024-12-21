resource "helm_release" "ingress_kong" {
  name             = "ingress-kong"
  namespace        = "ingress-kong"
  create_namespace = true

  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.42.0"

  values = [file("./values.yaml")]
}
