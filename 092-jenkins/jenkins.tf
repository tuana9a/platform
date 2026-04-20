import {
  to = kubernetes_namespace_v1.jenkins
  id = "jenkins"
}

resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_secret_v1" "google_login" {
  metadata {
    name      = "google-login"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  data = {
    client-id     = local.secrets.google-login.client-id
    client-secret = local.secrets.google-login.client-secret
  }
}

resource "helm_release" "jenkins" {
  depends_on = [kubernetes_secret_v1.google_login]

  name      = "jenkins"
  namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.10"

  values = [file("./values.yml")]
}
