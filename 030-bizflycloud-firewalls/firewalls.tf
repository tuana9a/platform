resource "bizflycloud_firewall" "pingable" {
  name = "pingable"
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

resource "bizflycloud_firewall" "openssh" {
  name = "openssh"
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

resource "bizflycloud_firewall" "openvpn" {
  name = "openvpn"
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

resource "bizflycloud_firewall" "web_access" {
  name = "web_access"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "80"
    protocol   = "tcp"
  }
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

resource "bizflycloud_firewall" "web_access_alternative" {
  name = "web_access_alternative"
  ingress {
    cidr       = "0.0.0.0/0"
    port_range = "8080"
    protocol   = "tcp"
  }
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

resource "bizflycloud_firewall" "wireguard" {
  name = "wireguard"
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

resource "bizflycloud_firewall" "proxmox" {
  name = "proxmox"
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
