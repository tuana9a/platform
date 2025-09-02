resource "kubernetes_manifest" "manifests" {
  for_each = fileset(path.module, "manifests/*.yaml")
  manifest = yamldecode(file(each.value))
}
