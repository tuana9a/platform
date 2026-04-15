resource "helm_release" "strimzi" {
  name             = "strimzi"
  namespace        = "strimzi-operator"
  create_namespace = true

  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.51.0"

  timeout = 10 * 60

  set {
    name  = "replicas"
    value = "2"
  }
}
