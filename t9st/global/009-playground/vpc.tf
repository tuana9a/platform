resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "vpc_2" {
  cidr_block = "10.2.0.0/16"
}
# ---

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"

  # assign public IP to ec2 when created - other words: public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc_2.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = "${data.aws_region.current.name}b"

  # assign public IP to ec2 when created - other words: public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_2"
  }
}

# ---

resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_1.id
}

resource "aws_internet_gateway" "igw_2" {
  vpc_id = aws_vpc.vpc_2.id
}

# ---

resource "aws_route" "route_1" {
  route_table_id         = aws_vpc.vpc_1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_1.id
}

resource "aws_route" "route_2" {
  route_table_id         = aws_vpc.vpc_2.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_2.id
}

