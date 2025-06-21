import {
  id = "apiVersion=v1,kind=ConfigMap,namespace=jenkins,name=general-jcasc"
  to = kubernetes_manifest.manifests["manifests/general.yml"]
}

import {
  id = "apiVersion=v1,kind=ConfigMap,namespace=jenkins,name=k8s-control-plane-jobs-jcasc"
  to = kubernetes_manifest.manifests["manifests/k8s-control-plane-jobs.yml"]
}

import {
  id = "apiVersion=v1,kind=ConfigMap,namespace=jenkins,name=oidc-jcasc"
  to = kubernetes_manifest.manifests["manifests/oidc.yml"]
}

import {
  id = "apiVersion=v1,kind=ConfigMap,namespace=jenkins,name=test-oidc-jcasc"
  to = kubernetes_manifest.manifests["manifests/test-oidc.yml"]
}
