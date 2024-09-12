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
}

resource "bizflycloud_firewall" "allow_openvpn" {
  name = "allow_openvpn"
  ingress {
    cidr       = "0.0.0.0/0"
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
}

resource "bizflycloud_firewall" "allow_http_alt" {
  name = "allow_http_alt"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "8080"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
}

resource "bizflycloud_firewall" "allow_https_alt" {
  name = "allow_https_alt"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "8443"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
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
}

resource "bizflycloud_firewall" "allow_proxmox" {
  name = "allow_proxmox"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "8006"
    protocol   = "tcp"
  }
  egress {
    cidr       = ""
    port_range = ""
    protocol   = ""
  }
}
