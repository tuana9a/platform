resource "coderd_template" "statefulset" {
  name        = "statefulset"
  description = "The main template for developing on k8s."
  versions = [
    {
      name        = "latest"
      description = "The latest version of the template."
      directory   = "./templates/statefulset"
      active      = true
      tf_vars = [{
        name  = "namespace"
        value = "coder"
      }]
    }
  ]
}
