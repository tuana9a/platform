resource "google_compute_network" "zero" {
  name = "zero"
  mtu  = 1460

  auto_create_subnetworks = false
}

moved {
  from = google_compute_subnetwork.zero_singapore
  to   = google_compute_subnetwork.zero_sg
}

resource "google_compute_subnetwork" "zero_sg" {
  name          = google_compute_network.zero.name
  ip_cidr_range = "10.0.0.0/16"
  region        = "asia-southeast1"
  network       = google_compute_network.zero.id
}

moved {
  from = google_compute_subnetwork.zero_tokyo
  to   = google_compute_subnetwork.zero_jp
}

resource "google_compute_subnetwork" "zero_jp" {
  name          = google_compute_network.zero.name
  ip_cidr_range = "10.1.0.0/16"
  region        = "asia-northeast1"
  network       = google_compute_network.zero.id
}
