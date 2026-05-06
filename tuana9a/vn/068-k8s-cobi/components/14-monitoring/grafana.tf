import {
  to = kubernetes_namespace_v1.grafana
  id = "grafana"
}

resource "kubernetes_namespace_v1" "grafana" {
  metadata {
    name = "grafana"
  }
}

resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = kubernetes_namespace_v1.grafana.metadata[0].name

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "10.5.8"

  values = [file("./grafana.yaml")]
}

resource "kubernetes_config_map_v1" "name" {
  metadata {
    name      = "datasources"
    namespace = kubernetes_namespace_v1.grafana.metadata[0].name
    labels = {
      grafana_datasource = "1"
    }
  }

  data = {
    "datasources.yaml" = file("./manifests/grafana-datasources.yaml")
  }
}
