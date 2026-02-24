###################################
# VPC
###################################

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "dev-vpc"
  }
}

###################################
# IGW
###################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "dev-igw"
  }
}

###################################
# Availability Zones
###################################

data "aws_availability_zones" "available" {}

###################################
# Route table
###################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "dev-public-rout_table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "dev-private-rout_table"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

###################################
# NAT
###################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}

###################################
# Subnets
###################################

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  count                   = length(var.public_subnets)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  count             = length(var.private_subnets)
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dev-private-subnet-${count.index}"
  }
}