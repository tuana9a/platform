resource "kubernetes_cluster_role" "tuana9a_gmail_com" {
  metadata {
    name = "tuana9a-gmail-com"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "tuana9a_gmail_com" {
  metadata {
    name = "tuana9a-gmail-com"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tuana9a_gmail_com.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "https://accounts.google.com#105303642619365489614"
    api_group = "rbac.authorization.k8s.io"
  }
}
