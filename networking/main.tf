#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

#Create VPC Public Subnet
resource "aws_subnet" "vpc_public_subnet" {
  count             = length(var.vpc_public_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.vpc_public_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#Create VPC Private Subnet
resource "aws_subnet" "vpc_private_subnet" {
  count             = length(var.vpc_private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.vpc_private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#Create VPC Internet Gatway
resource "aws_internet_gateway" "internet_gatway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "internet_gatway"
  }
}

#Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gatway.id
  }
  tags = {
    Name = "public route table"
  }
}

#Public route table association
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.vpc_public_subnet)
  subnet_id      = aws_subnet.vpc_public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#Public Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private route table"
  }
}

#Public route table association
resource "aws_route_table_association" "private_route_table_associationame" {
  count          = length(aws_subnet.vpc_private_subnet)
  subnet_id      = aws_subnet.vpc_private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
