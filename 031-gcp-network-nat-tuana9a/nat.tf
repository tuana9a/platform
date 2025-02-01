resource "google_compute_router" "nat" {
  name    = "nat"
  network = data.google_compute_network.zero.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.nat.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
