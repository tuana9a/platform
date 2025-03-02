resource "google_project_service" "container" {
  project = "tuana9a"
  service = "container.googleapis.com"
}

resource "google_project_service" "run" {
  project = "tuana9a"
  service = "run.googleapis.com"
}

resource "google_project_service" "serviceusage" {
  project = "tuana9a"
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "billingbudgets" {
  project = "tuana9a"
  service = "billingbudgets.googleapis.com"
}

resource "google_project_service" "cloudbilling" {
  project = "tuana9a"
  service = "cloudbilling.googleapis.com"
}
