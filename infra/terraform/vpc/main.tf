data "aws_availability_zones" "az" {}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.deployment_prefix}-main"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "${var.deployment_prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  # count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.az.names[0]

  tags = {
    Name = "${var.deployment_prefix}-private-subnet"
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
# nat in bastion subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
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


# private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "${var.deployment_prefix}-private-rt"
  }
}

# link private-rt to private subnets
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

