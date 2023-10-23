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

resource "aws_instance" "zion" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazonlinux2023.id
  key_name      = aws_key_pair.dev.id
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [
    aws_security_group.allow_everything.id
  ]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "zion"
    SSM  = "yes"
  }
}

resource "aws_eip" "zion" {
  vpc      = true
  instance = aws_instance.zion.id
}

resource "cloudflare_record" "zion" {
  zone_id = var.cloudflare_zone_id
  name    = "zion"
  value   = aws_eip.zion.public_ip
  type    = "A"
  ttl     = 86400
  proxied = false
}
