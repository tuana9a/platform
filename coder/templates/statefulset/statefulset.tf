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

        # NOTE: to fix the ownership of the folder
        # init_container {
        #   name              = "chown-data"
        #   image             = "docker.io/library/busybox:1.31.1"
        #   image_pull_policy = "IfNotPresent"
        #   command           = ["chown", "1000:1000", "/home/rootless/.local/share/docker"]
        #   security_context {
        #     capabilities {
        #       add = ["CHOWN"]
        #     }
        #     run_as_non_root = false
        #     run_as_user     = 0
        #   }
        #   volume_mount {
        #     mount_path = "/home/rootless/.local/share/docker"
        #     name       = "docker-data"
        #   }
        # }

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
          dynamic "env" {
            for_each = local.dockerd_dynamic
            content {
              name  = "DOCKER_CERT_PATH"
              value = "/certs/client"
            }
          }
          dynamic "env" {
            for_each = local.dockerd_dynamic
            content {
              name  = "DOCKER_TLS"
              value = "1"
            }
          }
          dynamic "env" {
            for_each = local.dockerd_dynamic
            content {
              name  = "DOCKER_HOST"
              value = "tcp://localhost:2376" # seriously, don't ask
            }
          }
          resources {
            requests = {
              "cpu"    = "250m"
              "memory" = "1024Mi"
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
          dynamic "volume_mount" {
            for_each = local.dockerd_dynamic
            content {
              name       = "docker-certs"
              sub_path   = "client"
              mount_path = "/certs/client"
              read_only  = true
            }
          }
        }

        dynamic "container" {
          for_each = local.dockerd_dynamic

          content {
            name  = "docker"
            image = "docker:27.0-dind"
            security_context {
              run_as_user = "0"
              privileged  = true
            }
            resources {
              requests = {
                "cpu"    = "1"
                "memory" = "2Gi"
              }
              limits = {
                "cpu"    = "2"
                "memory" = "4Gi"
              }
            }
            env {
              name  = "DOCKER_TLS_CERTDIR"
              value = "/certs"
            }
            volume_mount {
              name       = "docker-certs"
              mount_path = "/certs"
              read_only  = false
            }
            dynamic "volume_mount" {
              for_each = local.dockerd_persistent_dynamic
              content {
                name       = "docker-data"
                mount_path = "/var/lib/docker"
                read_only  = false
              }
            }
          }
        }

        dynamic "volume" {
          for_each = local.dockerd_dynamic

          content {
            name = "docker-certs"
            empty_dir {
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
          storage_class_name = "nfs567"
          resources {
            requests = {
              storage = "${data.coder_parameter.home_disk_size.value}Gi"
            }
          }
        }
      }
    }

    # https://github.com/docker/for-linux/issues/1172 Is your $HOME/.local/share/docker is on NFS? Then probably it does not work.
    dynamic "volume_claim_template" {
      for_each = local.dockerd_persistent_dynamic

      content {
        metadata {
          name      = "docker-data"
          namespace = var.namespace
        }
        spec {
          access_modes       = ["ReadWriteOnce"]
          storage_class_name = "nfs567"
          resources {
            requests = {
              storage = "20Gi"
            }
          }
        }
      }
    }
  }
}
