data "aws_availability_zones" "available" {
  state = "available"
}

data "cloudflare_zones" "tuana9a_com" {
  filter {
    name = "tuana9a.com"
  }
}
