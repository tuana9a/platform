locals {
  wireguard = {
    labels = {
      app       = "wireguard-client"
      component = "vpn"
      managed   = "terraform"
    }
  }
}


resource "kubernetes_namespace_v1" "wireguard" {
  metadata {
    name   = "wireguard"
    labels = local.wireguard.labels
  }
}

resource "kubernetes_secret_v1" "wireguard_client_configs" {
  metadata {
    name      = "wireguard-client-configs"
    namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
    labels    = local.wireguard.labels
  }

  # type: Opaque (default) is correct for arbitrary key-value data
  type = "Opaque"

  data = {
    # Key name becomes the filename when mounted as a volume
    "k8s-cobi-5.conf" = local.secrets.wireguard.client_configs["k8s-cobi-5.conf"]
  }
}

resource "kubernetes_deployment_v1" "wireguard_client" {
  metadata {
    name      = "wireguard-client"
    namespace = kubernetes_namespace_v1.wireguard.metadata[0].name
    labels    = local.wireguard.labels
  }

  spec {
    replicas = 1

    # WireGuard is stateful – rolling update keeps a single active tunnel
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "wireguard-client"
      }
    }

    template {
      metadata {
        labels = {
          app = "wireguard-client"
        }
      }

      spec {
        host_network = true

        container {
          name  = "wireguard-client"
          image = "lscr.io/linuxserver/wireguard:latest"

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
                wg-quick down /etc/wireguard/k8s-cobi-5.conf || true
                exit 0
              }
              trap cleanup TERM INT EXIT

              echo "[wireguard] Bringing up"
              wg-quick up /etc/wireguard/k8s-cobi-5.conf

              echo "[wireguard] Tunnel is up sleeping until signal"
              sleep infinity &
              wait $!
            EOT
          ]

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
              command = ["wg", "show", "k8s-cobi-5"]
            }
            initial_delay_seconds = 10
            period_seconds        = 30
            failure_threshold     = 3
          }
        }

        # ── Volumes ──────────────────────────────────────────
        volume {
          name = "wireguard-config"
          secret {
            secret_name  = kubernetes_secret_v1.wireguard_client_configs.metadata[0].name
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

  depends_on = [
    kubernetes_secret_v1.wireguard_client_configs,
    kubernetes_namespace_v1.wireguard,
  ]
}
