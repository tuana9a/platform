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
