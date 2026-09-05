resource "kubernetes_service_account" "zeus" {
  metadata {
    name      = "zeus"
    namespace = data.kubernetes_namespace_v1.default.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "zeus" {
  metadata {
    name = "zeus"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "zeus" {
  metadata {
    name = "zeus"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.zeus.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.zeus.metadata[0].name
    namespace = kubernetes_service_account.zeus.metadata[0].namespace
    api_group = ""
  }
}