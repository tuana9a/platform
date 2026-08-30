resource "bizflycloud_firewall" "megatron" {
  name = "megatron"

  # allow_ping
  ingress {
    cidr     = "0.0.0.0/0"
    protocol = "icmp"
  }

  # allow_ssh
  ingress {
    cidr       = "14.0.0.0/0"
    port_range = "22"
    protocol   = "tcp"
  }

  # allow_http
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "80"
    protocol   = "tcp"
  }

  # allow_https
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "443"
    protocol   = "tcp"
  }

  # allow_wireguard
  ingress {
    cidr       = "14.0.0.0/0"
    port_range = "51820"
    protocol   = "udp"
  }

  # allow_node_exporter
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9100"
    protocol   = "tcp"
  }

  # allow_network_exporter
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9427"
    protocol   = "tcp"
  }

  # allow_haproxy_stats
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9000"
    protocol   = "tcp"
  }

  egress {
    cidr = "0.0.0.0/0"
  }
}
