# https://docs.aws.amazon.com/glue/latest/dg/set-up-vpc-dns.html
#VPC FOR Both Public and Private Subnet
resource "aws_vpc" "this" {
  cidr_block = "10.20.20.0/26"
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_support
  enable_dns_support = true
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_hostnames
  enable_dns_hostnames = true
  tags = {
    "Name" = "Application-1-vnet"
  }
}

#Private Subnet *2
resource "aws_subnet" "private-2a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.0/28"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "Application-1-private-2a"
  }
}
resource "aws_subnet" "private-2b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.16/28"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "Application-1-private-2b"
  }
}
#Public Subnet *2
resource "aws_subnet" "public-2a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.32/28"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "Application-1-public-2a"
  }
}
resource "aws_subnet" "public-2b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.48/28"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "Application-1-public-2b"
  }
}

#Route table for Public Subnets
resource "aws_route_table" "alb-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "Application-1-alb-route-table"
  }
}
resource "aws_route_table_association" "public-2a" {
  subnet_id      = aws_subnet.public-2a.id
  route_table_id = aws_route_table.alb-rt.id
}
resource "aws_route_table_association" "public-2b" {
  subnet_id      = aws_subnet.public-2b.id
  route_table_id = aws_route_table.alb-rt.id
}
resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "Application-1-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.alb-rt.id
  gateway_id             = aws_internet_gateway.this-igw.id
}

#NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "this-ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-2b.id
}
#Route to Internet for Private IPS
resource "aws_route_table" "nat-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "Application-1-nat-route-table"
  }
}

resource "aws_route" "nat-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.nat-rt.id
  nat_gateway_id         = aws_nat_gateway.this-ngw.id
}

resource "aws_route_table_association" "private-2a" {
  subnet_id      = aws_subnet.private-2a.id
  route_table_id = aws_route_table.nat-rt.id
}
resource "aws_route_table_association" "private-2b" {
  subnet_id      = aws_subnet.private-2b.id
  route_table_id = aws_route_table.nat-rt.id
}