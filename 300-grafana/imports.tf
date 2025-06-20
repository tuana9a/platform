import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=grafana,name=admin-login"
  to = kubernetes_manifest.admin_login_secret
}

import {
  id = "apiVersion=v1,kind=ConfigMap,name=datasources,namespace=grafana"
  to = kubernetes_manifest.datasources
}
