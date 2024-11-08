resource "google_cloud_run_v2_service" "paste" {
  name     = "paste"
  location = var.gcp_region_name
  client   = "terraform"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      image = "tuana9a/paste-go:1.0.0"
      resources {
        limits = {
          cpu    = "1"
          memory = "1024Mi"
        }
      }
      env {
        name  = "BIND"
        value = "0.0.0.0"
      }
      env {
        name  = "REDIS_URL"
        value = data.vault_kv_secret.redis.data.REDIS_URL
      }
      env {
        name  = "REDIS_PASS"
        value = data.vault_kv_secret.redis.data.REDIS_PASS
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "paste_noauth" {
  location = google_cloud_run_v2_service.paste.location
  name     = google_cloud_run_v2_service.paste.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
