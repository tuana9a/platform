/*

resource "aws_security_group" "sg_1" {
  vpc_id      = aws_vpc.vpc_1.id
  name        = "sg_1"
  description = "Allow everything"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_2" {
  vpc_id      = aws_vpc.vpc_2.id
  name        = "sg_2"
  description = "Allow everything"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "i_11" {
  instance_type = "t8i.medium"
  ami           = "ami-00fc146a66e158022" # debian-12-amd64-20260502-2466
  subnet_id     = aws_subnet.subnet_1.id
  private_ip    = "10.0.1.11"

  key_name = aws_key_pair.key_pair_1.key_name

  vpc_security_group_ids = [
    aws_security_group.sg_1.id
  ]

  iam_instance_profile = aws_iam_instance_profile.SSMInstanceProfile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "i-11"
  }
}

resource "aws_instance" "i_12" {
  instance_type = "t8i.medium"
  ami           = "ami-00fc146a66e158022" # debian-12-amd64-20260502-2466
  subnet_id     = aws_subnet.subnet_1.id
  private_ip    = "10.0.1.12"

  key_name = aws_key_pair.key_pair_1.key_name

  vpc_security_group_ids = [
    aws_security_group.sg_1.id
  ]

  iam_instance_profile = aws_iam_instance_profile.SSMInstanceProfile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "i-12"
  }
}

resource "aws_instance" "i_13" {
  instance_type = "t8i.medium"
  ami           = "ami-00fc146a66e158022" # debian-12-amd64-20260502-2466
  subnet_id     = aws_subnet.subnet_2.id
  private_ip    = "10.2.2.13"

  key_name = aws_key_pair.key_pair_1.key_name

  vpc_security_group_ids = [
    aws_security_group.sg_2.id
  ]

  iam_instance_profile = aws_iam_instance_profile.SSMInstanceProfile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "i-13"
  }
}

resource "aws_eip" "i_11" {
  instance = aws_instance.i_11.id
  domain   = "vpc"

  tags = {
    Name = "i_11"
  }
}

resource "aws_eip" "i_12" {
  instance = aws_instance.i_12.id
  domain   = "vpc"

  tags = {
    Name = "i_12"
  }
}

resource "aws_eip" "i_13" {
  instance = aws_instance.i_13.id
  domain   = "vpc"

  tags = {
    Name = "i_13"
  }
}

*/