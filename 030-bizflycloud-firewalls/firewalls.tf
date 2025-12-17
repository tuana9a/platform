# combine all rules in one firewall for performance of terraform apply
# also I think it reduces number of api calls to bizflycloud
resource "bizflycloud_firewall" "orisis" {
  name = "orisis"

  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]

  # allow_ping
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = ""
    protocol   = "icmp"
  }

  # allow_ssh
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "22"
    protocol   = "tcp"
  }

  # allow_openvpn
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "1194"
    protocol   = "udp"
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
    cidr       = "0.0.0.0/0"
    port_range = "51820"
    protocol   = "udp"
  }

  # allow_proxmox
  ingress {
    cidr       = "14.0.0.0/0"
    port_range = "8006"
    protocol   = "tcp"
  }

  # allow_node_exporter
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9100"
    protocol   = "tcp"
  }

  # allow_haproxy_stats
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9000"
    protocol   = "tcp"
  }
}
