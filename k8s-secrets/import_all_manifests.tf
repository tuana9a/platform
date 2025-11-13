import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=prometheus,name=alertmanager"
  to = kubernetes_manifest.manifests["manifests/alertmanager.yaml"]
}

import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=jenkins,name=502-coder-postgres-backup-env"
  to = kubernetes_manifest.manifests["manifests/502-coder-postgres-backup-env.yaml"]
}

import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=jenkins,name=511-dkhptd-mongo-backup-env"
  to = kubernetes_manifest.manifests["manifests/511-dkhptd-mongo-backup-env.yaml"]
}
