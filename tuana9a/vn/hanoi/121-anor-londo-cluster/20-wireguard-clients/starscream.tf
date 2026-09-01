module "starscream_parsed_wireguard_config" {
  source  = "./modules/parse-wireguard-config"
  content = data.vault_kv_secret_v2.wireguard_clients.data.starscream-0_conf
}

locals {
  starscream_gateway_ip = nonsensitive(module.starscream_parsed_wireguard_config.wg_gateway)
}

resource "kubernetes_secret_v1" "starscream_clients" {
  metadata {
    name      = "starscream-clients"
    namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
    labels    = local.wireguard.labels
  }

  # type: Opaque (default) is correct for arbitrary key-value data
  type = "Opaque"

  data = {
    # Key name becomes the filename when mounted as a volume
    "starscream-0.conf" = data.vault_kv_secret_v2.wireguard_clients.data.starscream-0_conf
    "starscream-1.conf" = data.vault_kv_secret_v2.wireguard_clients.data.starscream-1_conf
    "starscream-2.conf" = data.vault_kv_secret_v2.wireguard_clients.data.starscream-2_conf
  }
}

resource "kubernetes_stateful_set_v1" "starscream" {
  metadata {
    name      = "starscream"
    namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
    labels    = local.wireguard.labels
  }

  spec {
    service_name = "wg"
    replicas     = 2

    selector {
      match_labels = {
        app = "starscream"
      }
    }

    template {
      metadata {
        labels = {
          app = "starscream"
        }
      }

      spec {
        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["starscream"]
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
          image = "lscr.io/linuxserver/wireguard:1.0.20250521-r1-ls113"

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
            privileged = true
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "50M"
            }
            limits = {
              memory = "50M"
            }
          }

          volume_mount {
            name       = "wireguard-config"
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
              command = ["ping", "-c", "1", local.starscream_gateway_ip]
            }
            initial_delay_seconds = 3
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 3
          }
        }

        # ── Volumes ──────────────────────────────────────────
        volume {
          name = "wireguard-config"
          secret {
            secret_name  = kubernetes_secret_v1.starscream_clients.metadata[0].name
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

        # Only schedule on Linux nodes (required for WireGuard kernel module)
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
