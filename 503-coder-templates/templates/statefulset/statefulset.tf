resource "kubernetes_stateful_set" "main" {
  count            = local.me.start_count
  wait_for_rollout = false
  metadata {
    name      = "coder-${lower(local.me.owner)}-${lower(local.me.name)}"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = "coder-workspace-${lower(local.me.owner)}-${lower(local.me.name)}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = local.me.id
      "com.coder.workspace.name"   = local.me.name
      "com.coder.user.id"          = local.me.owner_id
      "com.coder.user.username"    = local.me.owner
    }
    annotations = {
      "com.coder.user.email" = local.me.owner_email
    }
  }

  spec {
    replicas = 1

    service_name = local.me.name

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "coder-workspace"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "coder-workspace"
        }
      }
      spec {
        security_context {
          fs_group     = "1000"
          run_as_user  = "1000"
          run_as_group = "1000"
        }

        container {
          name              = "dev"
          image             = "tuana9a/coder:${data.coder_parameter.image_tag.value}"
          image_pull_policy = "Always"
          command           = ["sh", "-c", coder_agent.main.init_script]
          security_context {
            run_as_user = "1000"
          }
          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          resources {
            requests = {
              "cpu"    = "10m"
              "memory" = "${data.coder_parameter.memory.value}Gi"
            }
            limits = {
              "cpu"    = "${data.coder_parameter.cpu.value}"
              "memory" = "${data.coder_parameter.memory.value}Gi"
            }
          }
          dynamic "volume_mount" {
            for_each = local.home_persistent_dynamic
            content {
              mount_path = "/home/coder"
              name       = "home"
              read_only  = false
            }
          }
        }

        affinity {
          // This affinity attempts to spread out all workspace pods evenly across
          // nodes.
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["coder-workspace"]
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "volume_claim_template" {
      for_each = local.home_persistent_dynamic

      content {
        metadata {
          name      = "home"
          namespace = var.namespace
          labels = {
            "app.kubernetes.io/name"     = "coder-pvc"
            "app.kubernetes.io/instance" = "coder-pvc-${lower(local.me.owner)}-${lower(local.me.name)}"
            "app.kubernetes.io/part-of"  = "coder"
            //Coder-specific labels.
            "com.coder.resource"       = "true"
            "com.coder.workspace.id"   = local.me.id
            "com.coder.workspace.name" = local.me.name
            "com.coder.user.id"        = local.me.owner_id
            "com.coder.user.username"  = local.me.owner
          }
          annotations = {
            "com.coder.user.email" = local.me.owner_email
          }
        }
        spec {
          access_modes       = ["ReadWriteOnce"]
          storage_class_name = data.coder_parameter.home_storage_class.value
          resources {
            requests = {
              storage = "${data.coder_parameter.home_disk_size.value}Gi"
            }
          }
        }
      }
    }
  }
}
