# NOTE: at first all pods will be pending, it will wait until real workload from us
resource "google_container_cluster" "zero" {
  name             = "zero"
  location         = "asia-southeast1"
  network          = data.google_compute_network.zero.name
  subnetwork       = data.google_compute_subnetwork.zero_singapore.name
  enable_autopilot = true

  deletion_protection = true
}