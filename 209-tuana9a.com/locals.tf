locals {
  my_domain = "tuana9a.com"
}

data "cloudflare_zone" "tuana9a_com" {
  filter = {
    name = "tuana9a.com"
  }
}
