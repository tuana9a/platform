resource "kubernetes_manifest" "manifests" {
  for_each = fileset(path.module, "*.yaml")
  manifest = yamldecode(file(each.value))
}
