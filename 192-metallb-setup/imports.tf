
import {
  id = "apiVersion=metallb.io/v1beta1,kind=IPAddressPool,namespace=metallb-system,name=vmbr56"
  to = kubernetes_manifest.manifests["manifests/vmbr56-IPAddressPool.yaml"]
}

import {
  id = "apiVersion=metallb.io/v1beta1,kind=L2Advertisement,namespace=metallb-system,name=vmbr56"
  to = kubernetes_manifest.manifests["manifests/vmbr56-L2Advertisement.yaml"]
}