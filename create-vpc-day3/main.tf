# AWS Provider Configuration
provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

# Create a VPC for the application
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

# Create public subnets for application resources
resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app-internet-gateway"
  }
}

# Create a route for the public route table to allow outbound traffic
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

# Create private subnets for application resources
resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "private-subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# Create a route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain   = "vpc"
}

# Create a NAT Gateway in the first public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "app-nat-gateway"
  }

  # Ensure proper ordering by depending on the Internet Gateway
  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create a route for private subnets to allow outbound traffic through the NAT Gateway
resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gateway.id
}

# Create database subnets for application resources
resource "aws_subnet" "db_subnet" {
  count = length(var.db_cidr_block)
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.db_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "db-subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# Create a route table for database subnets
resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "db-route-table"
  }
}

# Associate database subnets with the database route table
resource "aws_route_table_association" "db_subnet_association" {
  count = length(var.db_cidr_block)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_route_table.id
}

# Create a route for the database subnets to allow outbound traffic through the NAT Gateway
resource "aws_route" "db_route" {
  route_table_id            = aws_route_table.db_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gateway.id
}

# Create a DB subnet group for RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id

  tags = {
    Name = "Database Subnet Group"
  }
}
