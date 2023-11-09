resource "aws_vpc" "zero" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "zero_zero" {
  vpc_id            = aws_vpc.zero.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true # auto assign public ip to newly created instances, default is false
}

resource "aws_internet_gateway" "zero" {
  vpc_id = aws_vpc.zero.id
}

resource "aws_route" "zero_to_public" {
  route_table_id         = aws_vpc.zero.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.zero.id
}

resource "aws_security_group" "zero" {
  vpc_id      = aws_vpc.zero.id
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
