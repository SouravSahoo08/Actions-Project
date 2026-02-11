resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  count = length(var.public_subnets)
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  count = length(var.public_subnets)
  cidr_block = var.private_subnets[count.index]
}