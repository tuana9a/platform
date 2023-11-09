data "aws_availability_zones" "available" {
  state = "available"
}

data "cloudflare_zones" "tuana9a_com" {
  filter {
    name = "tuana9a.com"
  }
}

resource "aws_iam_account_alias" "tuana9a" {
  account_alias = "tuana9a"
}