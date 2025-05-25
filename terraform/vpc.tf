// VPC

resource "aws_vpc" "copa_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "copa-vpc"
  }
}

// Subnets

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.copa_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "copa-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.copa_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "copa-public-b"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.copa_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "copa-private-a"
  }
}

// IGW && Public Route Table

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.copa_vpc.id
  tags = {
    Name = "copa-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.copa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "copa-public-rt"
  }
}

// NAT Gateway && Private Route Table

resource "aws_eip" "copa_nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "copa_nat" {
  allocation_id = aws_eip.copa_nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "copa-nat-gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.copa_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.copa_nat.id
  }

  tags = {
    Name = "copa-private-rt"
  }
}

// Route Table Associations

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}
