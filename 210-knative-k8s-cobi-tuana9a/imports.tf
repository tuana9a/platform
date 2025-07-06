import {
  id = "apiVersion=v1,kind=Namespace,name=knative-eventing"
  to = kubernetes_manifest.manifests["manifests/ns-knative-eventing.yml"]
}

import {
  id = "apiVersion=v1,kind=Namespace,name=knative-serving"
  to = kubernetes_manifest.manifests["manifests/ns-knative-serving.yml"]
}

import {
  id = "apiVersion=operator.knative.dev/v1beta1,kind=KnativeEventing,namespace=knative-eventing,name=knative-eventing"
  to = kubernetes_manifest.manifests["manifests/knative-eventing.yml"]
}

import {
  id = "apiVersion=operator.knative.dev/v1beta1,kind=KnativeServing,namespace=knative-serving,name=knative-serving"
  to = kubernetes_manifest.manifests["manifests/knative-serving.yml"]
}
