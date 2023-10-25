resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true # auto assign public ip to newly created instances, default is false
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "access_public_internet" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_security_group" "allow_everything" {
  vpc_id      = aws_vpc.main.id
  name        = "allow everything"
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
