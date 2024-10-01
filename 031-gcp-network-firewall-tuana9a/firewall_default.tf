resource "google_compute_firewall" "zero_allow_icmp" {
  name     = "allow-icmp"
  network  = data.google_compute_network.zero.name
  priority = 65535

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "zero_allow_ssh" {
  name     = "allow-ssh"
  network  = data.google_compute_network.zero.name
  priority = 65535

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "zero_allow_internal" {
  name     = "allow-internal"
  network  = data.google_compute_network.zero.name
  priority = 65535

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
}
