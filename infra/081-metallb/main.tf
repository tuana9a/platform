locals {
  namespace = "metallb-system"
}

resource "helm_release" "ingress_nginx" {
  name             = "metallb"
  namespace        = local.namespace
  create_namespace = true

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.14.5"
}

resource "kubernetes_manifest" "vmbr56_ipaddresspool" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "IPAddressPool"
    "metadata" = {
      "name"      = "vmbr56"
      "namespace" = "${local.namespace}"
    }
    "spec" = {
      "addresses" = [
        "192.168.56.78-192.168.56.89",
      ]
    }
  }
}

resource "kubernetes_manifest" "vmbr56_l2advertisement" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "L2Advertisement"
    "metadata" = {
      "name"      = "vmbr56"
      "namespace" = "${local.namespace}"
    }
    "spec" = {
      "ipAddressPools" = [
        "vmbr56",
      ]
    }
  }
}
