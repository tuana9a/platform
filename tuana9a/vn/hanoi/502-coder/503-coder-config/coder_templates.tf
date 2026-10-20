resource "coderd_template" "statefulset" {
  name        = "statefulset"
  description = "Running statefulset code-server"
  versions = [
    {
      description = "Running statefulset code-server"
      directory   = "./templates/statefulset"
      active      = true
      tf_vars = [{
        name  = "namespace"
        value = "coder"
      }]
    }
  ]
}
