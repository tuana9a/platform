import {
  to = kubernetes_namespace_v1.coder
  id = "coder"
}

resource "kubernetes_namespace_v1" "coder" {
  metadata {
    name = "coder"
  }
}

resource "kubernetes_manifest" "coder_env" {
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  namespace: ${kubernetes_namespace_v1.coder.metadata[0].name}
  name: coder-env
spec:
  refreshInterval: "15s"
  secretStoreRef:
    name: vault-tuana9a-com
    kind: ClusterSecretStore
  target:
    name: coder-env
  dataFrom:
    - extract:
        key: coder/env
EOF
  )
}

resource "helm_release" "coder" {
  name      = "coder"
  namespace = kubernetes_namespace_v1.coder.metadata[0].name

  repository = "https://helm.coder.com/v2"
  chart      = "coder"
  version    = "2.23.1"

  values = [file("./values.yaml")]

  depends_on = [kubernetes_manifest.coder_env]
}
