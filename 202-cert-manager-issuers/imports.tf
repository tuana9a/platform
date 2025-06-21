import {
  id = "apiVersion=cert-manager.io/v1,kind=ClusterIssuer,name=letsencrypt-cloudflare-production"
  to = kubernetes_manifest.manifests["manifests/cluster-issuer-letsencrypt-cloudflare-production.yml"]
}

import {
  id = "apiVersion=cert-manager.io/v1,kind=ClusterIssuer,name=letsencrypt-production"
  to = kubernetes_manifest.manifests["manifests/cluster-issuer-letsencrypt-production.yml"]
}
