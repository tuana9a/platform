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

  repository = "oci://ghcr.io/grafana-community/helm-charts"
  chart      = "grafana"
  version    = "13.0.1"

  values = [file("./grafana-values.yaml")]
}

resource "kubernetes_config_map_v1" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = kubernetes_namespace_v1.grafana.metadata[0].name
    labels = {
      grafana_datasource = "1"
    }
  }

  data = {
    "datasources.yaml" = file("./grafana-datasources.yaml")
  }
}
