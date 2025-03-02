data "vault_kv_secret" "redis" {
  path = "kv/paste/redis"
}

data "google_project" "current" {
}

data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

resource "google_cloud_run_v2_service" "paste" {
  name     = "paste"
  location = "asia-southeast1"
  client   = "terraform"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      image = "tuana9a/paste-go:2.0.0-6ecf562b"
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

# https://cloud.google.com/run/docs/mapping-custom-domains#terraform
resource "google_cloud_run_domain_mapping" "paste" {
  name     = cloudflare_record.paste.hostname
  location = google_cloud_run_v2_service.paste.location
  metadata {
    namespace = data.google_project.current.project_id
  }
  spec {
    route_name = google_cloud_run_v2_service.paste.name
  }
}

# https://console.cloud.google.com/run/domains
resource "cloudflare_record" "paste" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "paste"
  value   = "ghs.googlehosted.com."
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
