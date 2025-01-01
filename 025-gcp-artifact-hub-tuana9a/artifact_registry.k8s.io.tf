resource "google_artifact_registry_repository" "registry_k8s_io" {
  location      = var.gcp_region_name
  repository_id = "registry-k8s-io"
  description   = "mirroring registry.k8s.io"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "registry_k8s_io" {
  project    = google_artifact_registry_repository.registry_k8s_io.project
  location   = google_artifact_registry_repository.registry_k8s_io.location
  repository = google_artifact_registry_repository.registry_k8s_io.name
  role       = "roles/artifactregistry.reader"
  members    = ["allUsers"]
}
