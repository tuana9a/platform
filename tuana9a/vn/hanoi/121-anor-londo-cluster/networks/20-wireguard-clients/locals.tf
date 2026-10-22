locals {
  wireguard = {
    labels = {
      app       = "wireguard-client"
      component = "vpn"
      managed   = "terraform"
    }
  }
}