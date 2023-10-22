data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "zion" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ubuntu_server.id
  key_name      = aws_key_pair.key_pair_1.id
  subnet_id     = aws_subnet.subnet_1.id

  vpc_security_group_ids = [
    aws_security_group.sg_1.id
  ]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "zion"
  }
}

resource "aws_eip" "zion" {
  vpc      = true
  instance = aws_instance.zion.id
}
