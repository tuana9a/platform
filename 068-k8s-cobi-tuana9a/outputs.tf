/*
https://github.com/sergelogvinov/proxmox-csi-plugin/blob/main/docs/install.md#prepare-kubernetes-cluster

Proxmox CSI Plugin relies on the well-known Kubernetes topology node labels to define the disk location.
  topology.kubernetes.io/region - Cluster name, the name must be the same as in cloud config region name
  topology.kubernetes.io/zone - Proxmox node name

*/

locals {
  node_labels = [for key, node in local.cluster : ({
    nodename = key
    labels = [
      "topology.kubernetes.io/region=alien",
      "topology.kubernetes.io/zone=${node.pve_node}",
    ]
  })]
  node_labels_yaml = yamlencode(local.node_labels)
}

resource "local_file" "node_labels_yaml" {
  content  = local.node_labels_yaml
  filename = "${path.module}/files/generated/node_labels.yaml"
}
