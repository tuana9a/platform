data "google_compute_subnetwork" "zero_singapore" {
  region = "asia-southeast1"
  name   = data.google_compute_network.zero.name
}
