data "aws_availability_zones" "az" {}
# main vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.deployment_prefix}-main"
  }
}
# public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "${var.deployment_prefix}-public-subnet-${count.index + 1}"
  }
}
# wordpress subnet
resource "aws_subnet" "wordpress" {
  count             = length(var.wordpress_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.wordpress_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "${var.deployment_prefix}-wordpres-subnet-${count.index + 1}"
  }
}
# rds subnet
resource "aws_subnet" "rds" {
  count             = length(var.rds_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.rds_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "${var.deployment_prefix}-rds-subnet-${count.index + 1}"
  }
}
# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.deployment_prefix}-myigw"
  }
}
# static ip for nat
resource "aws_eip" "nat_eip" {
  tags = {
    "Name" = "${var.deployment_prefix}-nat-eip"
  }
}
# nat in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[1].id
  tags = {
    "Name" = "${var.deployment_prefix}-nat"
  }
}
# public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-public-rt"
  }
}

# link public-rt to pubclic subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# wordpress route table
resource "aws_route_table" "wordpress_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-wordpress-rt"
  }
}
# link wordpress-rt to wordpress subnets
resource "aws_route_table_association" "wordpress" {
  count          = length(var.wordpress_subnet_cidr)
  subnet_id      = aws_subnet.wordpress[count.index].id
  route_table_id = aws_route_table.wordpress_rt.id
}
