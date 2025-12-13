resource "bizflycloud_firewall" "allow_ping" {
  name = "allow_ping"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = ""
    protocol   = "icmp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_ssh" {
  name = "allow_ssh"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "22"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_openvpn" {
  name = "allow_openvpn"
  ingress {
    cidr       = "14.0.0.0/0"
    port_range = "1194"
    protocol   = "udp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
}

resource "bizflycloud_firewall" "allow_http" {
  name = "allow_http"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "80"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_https" {
  name = "allow_https"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "443"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_wireguard" {
  name = "allow_wireguard"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "51820"
    protocol   = "udp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_proxmox" {
  name = "allow_proxmox"
  ingress {
    cidr       = "14.0.0.0/0"
    port_range = "8006"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
}

resource "bizflycloud_firewall" "allow_node_exporter" {
  name = "allow_node_exporter"
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9100"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}

resource "bizflycloud_firewall" "allow_haproxy_stats" {
  name = "allow_haproxy_stats"
  ingress {
    cidr       = "14.0.0.0/8"
    port_range = "9000"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
  network_interfaces = [
    local.servers.orisis.network_interfaces.0.id,
  ]
}
