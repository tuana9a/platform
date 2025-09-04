import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=510-d9stbot"
  to = kubernetes_manifest.manifests["510-d9stbot.yaml"]
}

import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=510-t9stbot"
  to = kubernetes_manifest.manifests["510-t9stbot.yaml"]
}

import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=511-dkhptd"
  to = kubernetes_manifest.manifests["511-dkhptd.yaml"]
}

import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=512-hcr"
  to = kubernetes_manifest.manifests["512-hcr.yaml"]
}

import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=513-paste"
  to = kubernetes_manifest.manifests["513-paste.yaml"]
}

import {
  id = "apiVersion=argoproj.io/v1alpha1,kind=Application,namespace=argocd,name=600-k8s-forwarder"
  to = kubernetes_manifest.manifests["600-k8s-forwarder.yaml"]
}
