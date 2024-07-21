data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  os             = "linux"
  arch           = "amd64"
  startup_script = <<-EOT
    set -e

    # install and start code-server
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.11.0
    /tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
  EOT

  # The following metadata blocks are optional. They are used to display
  # information about your workspace in the dashboard. You can remove them
  # if you don't want to display any information.
  # For basic resources, you can use the `coder stat` command.
  # If you need more control, you can write your own script.
  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Home Disk"
    key          = "3_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }

  metadata {
    display_name = "CPU Usage (Host)"
    key          = "4_cpu_usage_host"
    script       = "coder stat cpu --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory Usage (Host)"
    key          = "5_mem_usage_host"
    script       = "coder stat mem --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Load Average (Host)"
    key          = "6_load_host"
    # get load avg scaled by number of cores
    script   = <<EOT
      echo "`cat /proc/loadavg | awk '{ print $1 }'` `nproc`" | awk '{ printf "%0.2f", $1/$2 }'
    EOT
    interval = 60
    timeout  = 1
  }
}

# code-server
resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  url          = "http://localhost:13337?folder=/home/coder"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "kubernetes_stateful_set" "main" {
  count            = data.coder_workspace.me.start_count
  wait_for_rollout = false
  metadata {
    name      = "coder-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = "coder-workspace-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace.me.owner_id
      "com.coder.user.username"    = data.coder_workspace.me.owner
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace.me.owner_email
    }
  }

  spec {
    replicas = 1

    service_name = data.coder_workspace.me.name

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
          run_as_user = 1000
          fs_group    = 1000
        }

        container {
          name              = "dev"
          image             = data.coder_parameter.image.value
          image_pull_policy = "Always"
          command           = ["sh", "-c", coder_agent.main.init_script]
          security_context {
            run_as_user = "1000"
          }
          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          env {
            name  = "DOCKER_CERT_PATH"
            value = "/certs/client"
          }
          env {
            name  = "DOCKER_TLS"
            value = "1"
          }
          env {
            name  = "DOCKER_HOST"
            value = "tcp://localhost:2376" # seriously, don't ask
          }
          resources {
            requests = {
              "cpu"    = "250m"
              "memory" = "512Mi"
            }
            limits = {
              "cpu"    = "${data.coder_parameter.cpu.value}"
              "memory" = "${data.coder_parameter.memory.value}Gi"
            }
          }
          volume_mount {
            mount_path = "/home/coder"
            name       = "home"
            read_only  = false
          }
          volume_mount {
            name       = "docker-certs"
            sub_path   = "client"
            mount_path = "/certs/client"
            read_only  = true
          }
        }

        # https://github.com/docker/for-linux/issues/1172 Is your $HOME/.local/share/docker is on NFS? Then probably it does not work.
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
          name  = "docker"
          image = "docker:27.0-dind-rootless"
          security_context {
            run_as_user = "1000"
            privileged  = true
          }
          resources {
            requests = {
              "cpu"    = "250m"
              "memory" = "512Mi"
            }
            limits = {
              "cpu"    = "1000m"
              "memory" = "2Gi"
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
          # https://github.com/docker/for-linux/issues/1172 Is your $HOME/.local/share/docker is on NFS? Then probably it does not work.
          # volume_mount {
          #   name       = "docker-data"
          #   mount_path = "/home/rootless/.local/share/docker"
          #   read_only  = false
          # }
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

    volume_claim_template {
      metadata {
        name      = "home"
        namespace = var.namespace
        labels = {
          "app.kubernetes.io/name"     = "coder-pvc"
          "app.kubernetes.io/instance" = "coder-pvc-${lower(data.coder_workspace.me.owner)}-${lower(data.coder_workspace.me.name)}"
          "app.kubernetes.io/part-of"  = "coder"
          //Coder-specific labels.
          "com.coder.resource"       = "true"
          "com.coder.workspace.id"   = data.coder_workspace.me.id
          "com.coder.workspace.name" = data.coder_workspace.me.name
          "com.coder.user.id"        = data.coder_workspace.me.owner_id
          "com.coder.user.username"  = data.coder_workspace.me.owner
        }
        annotations = {
          "com.coder.user.email" = data.coder_workspace.me.owner_email
        }
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "nfs-client"
        resources {
          requests = {
            storage = "${data.coder_parameter.home_disk_size.value}Gi"
          }
        }
      }
    }

    # volume_claim_template {
    #   metadata {
    #     name      = "docker-data"
    #     namespace = var.namespace
    #   }
    #   spec {
    #     access_modes       = ["ReadWriteOnce"]
    #     storage_class_name = "nfs-client"
    #     resources {
    #       requests = {
    #         storage = "32Gi"
    #       }
    #     }
    #   }
    # }

    volume_claim_template {
      metadata {
        name      = "docker-certs"
        namespace = var.namespace
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "nfs-client"
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}
