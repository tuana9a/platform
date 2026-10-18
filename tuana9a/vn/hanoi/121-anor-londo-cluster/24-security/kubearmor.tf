resource "kubernetes_namespace" "kubearmor" {
  metadata {
    name = "kubearmor"
  }
}

resource "helm_release" "kubearmor_operator" {
  name       = "kubearmor-operator"
  repository = "https://kubearmor.github.io/charts"
  chart      = "kubearmor-operator"
  namespace  = kubernetes_namespace.kubearmor.metadata[0].name

  create_namespace = false

  version = "1.7.6"
}
