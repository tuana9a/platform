import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=prometheus,name=alertmanager"
  to = kubernetes_manifest.alertmanager_secret
}