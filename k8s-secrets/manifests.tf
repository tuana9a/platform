resource "kubernetes_manifest" "manifests" {
  for_each = fileset(path.module, "manifests/*.y*ml")
  manifest = yamldecode(file(each.value))
  field_manager {
    force_conflicts = true
  }
}
