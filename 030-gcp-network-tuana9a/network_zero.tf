resource "google_compute_network" "zero" {
  name = "zero"
  mtu  = 1460

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "zero_singapore" {
  name          = google_compute_network.zero.name
  ip_cidr_range = "10.0.0.0/16"
  region        = "asia-southeast1"
  network       = google_compute_network.zero.id
}

resource "google_compute_subnetwork" "zero_tokyo" {
  name          = google_compute_network.zero.name
  ip_cidr_range = "10.1.0.0/16"
  region        = "asia-northeast1"
  network       = google_compute_network.zero.id
}
