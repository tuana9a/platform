resource "google_project_service" "container" {
  project = var.gcp_project_name
  service = "container.googleapis.com"
}

resource "google_project_service" "run" {
  project = var.gcp_project_name
  service = "run.googleapis.com"
}

resource "google_project_service" "serviceusage" {
  project = var.gcp_project_name
  service = "serviceusage.googleapis.com"
}
