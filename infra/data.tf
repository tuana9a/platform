data "aws_availability_zones" "available" {
  state = "available"
}

data "cloudflare_zones" "tuana9a_com" {
  filter {
    name = "tuana9a.com"
  }
}

data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20231021"]
  }
}

data "aws_ami" "amazonlinux2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230912.0-kernel-6.1-x86_64"]
  }
}
