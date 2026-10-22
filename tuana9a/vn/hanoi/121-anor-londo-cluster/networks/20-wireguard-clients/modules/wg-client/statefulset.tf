module "parsed_wireguard_config" {
  source  = "../parse-wireguard-config"
  content = var.wg_configs[0]
}

locals {
  name       = var.name
  namespace  = var.namespace
  gateway_ip = nonsensitive(module.parsed_wireguard_config.wg_gateway)
}

resource "kubernetes_secret_v1" "wg_configs" {
  metadata {
    name      = "${local.name}-wg-configs"
    namespace = local.namespace
  }

  # type: Opaque (default) is correct for arbitrary key-value data
  type = "Opaque"

  data = {
    # Key name becomes the filename when mounted as a volume
    for i, x in var.wg_configs : "${local.name}-${i}.conf" => x
  }
}

resource "kubernetes_stateful_set_v1" "this" {
  metadata {
    name      = local.name
    namespace = local.namespace
  }

  spec {
    service_name = "wg"
    replicas     = var.replicas

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.name
        }
      }

      spec {
        # Only schedule on Linux nodes (required for WireGuard kernel module)
        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = [local.name]
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        # NOTE: using topology_spread_constraint for better performance on large deployment
        # topology_spread_constraint {
        #   max_skew           = 1
        #   topology_key       = "kubernetes.io/hostname"
        #   when_unsatisfiable = "DoNotSchedule"
        #   label_selector {
        #     match_labels = {
        #       app = "starscream"
        #     }
        #   }
        # }

        host_network = true

        container {
          name  = "wireguard"
          image = var.wg_image

          # Keep the pod alive; the tunnel was started in the init container
          # The entrypoint script:
          #   1. Traps TERM/INT/EXIT → always runs wg-quick down
          #   2. Brings the tunnel up
          #   3. Sleeps indefinitely (interruptible), keeping the pod alive
          #
          # Using `sleep infinity` instead of a loop means the shell wakes
          # immediately on SIGTERM rather than waiting for a sleep interval.
          command = [
            "/bin/sh", "-c",
            <<-EOT
              set -e
              cleanup() {
                echo "[wireguard] Received shutdown signal bringing down"
                wg-quick down /etc/wireguard/$POD_NAME.conf || true
                exit 0
              }
              trap cleanup TERM INT EXIT

              echo "[wireguard] Bringing up"
              wg-quick up /etc/wireguard/$POD_NAME.conf

              echo "[wireguard] Tunnel is up sleeping until signal"
              sleep infinity &
              wait $!
            EOT
          ]

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN", "SYS_MODULE"]
            }
            # privileged = true # TODO: verify if necessary
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "10M"
            }
            limits = {
              memory = "10M"
            }
          }

          volume_mount {
            name       = "wg-configs"
            mount_path = "/etc/wireguard"
            read_only  = true
          }

          volume_mount {
            name       = "lib-modules"
            mount_path = "/lib/modules"
            read_only  = true
          }

          # Optional: liveness probe – checks that wg interface is up
          liveness_probe {
            exec {
              command = ["ping", "-c", "1", local.gateway_ip]
            }
            initial_delay_seconds = 3
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 3
          }
        }

        # ── Volumes ──────────────────────────────────────────
        volume {
          name = "wg-configs"
          secret {
            secret_name  = kubernetes_secret_v1.wg_configs.metadata[0].name
            default_mode = "0400" # owner read-only .conf contains private keys
          }
        }

        volume {
          name = "lib-modules"
          host_path {
            path = "/lib/modules"
            type = "Directory"
          }
        }

        restart_policy = "Always"
      }
    }
  }
}
