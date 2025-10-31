resource "coderd_template" "statefulset" {
  name        = "statefulset"
  description = "A code-server running as statefulset"
  versions = [
    {
      description = "A code-server running as statefulset"
      directory   = "./templates/statefulset"
      active      = true
      tf_vars = [{
        name  = "namespace"
        value = "coder"
      }]
    }
  ]
}
