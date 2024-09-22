# provider "aws" {
#   access_key = data.vault_aws_access_credentials.creds.access_key
#   secret_key = data.vault_aws_access_credentials.creds.secret_key
# }


resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "vault-vpc"
  }
}
resource "aws_subnet" "public" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "public_subnet_rt"
  }
}
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vault-vpc GW"
  }
}

resource "aws_route" "r" {
  route_table_id            = aws_route_table.public_subnet_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


#  private 
resource "aws_subnet" "private" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "private subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "private_subnet_rt"
  }
}
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "vault-vpc NGW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_subnet_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.example.id
}

## DB 
resource "aws_subnet" "db_subnet" {
  count = length(var.db_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "db subnet-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}
resource "aws_route_table" "db_subnet_rt" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "db_subnet_rt"
  }
}
resource "aws_route_table_association" "db" {
  count = length(var.db_cidr_block)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_subnet_rt.id
}
resource "aws_route" "db_route" {
  route_table_id            = aws_route_table.db_subnet_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.example.id
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-group"
  subnet_ids = aws_subnet.db_subnet[*].id

  tags = {
    Name = "Vault Cluster DB subnet group"
  }
}