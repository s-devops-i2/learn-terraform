resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/24"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "frontend" {
  count             = length(var.frontend_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "frontend-subnet${count.index+1}"
  }
}

resource "aws_route_table" "frontend-rt" {
  count  = length(var.frontend_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block                = var.default_vpc_cidr_block
    vpc_peering_connection_id = var.peer_connection_id

  }
  route {
    cidr_block                = "0.0.0.0"
    gateway_id                = aws_nat_gateway.ngw[count.index].id

  }

  tags = {
    Name = "${var.env}-frontend-rt${count.index+1}"
  }
}

resource "aws_route_table_association" "frontend-rt-assoc" {
  count          = length(var.frontend_subnets)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend-rt[count.index].id
}

resource "aws_subnet" "backend" {
  count             = length(var.backend_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "backend-subnet${count.index+1}"
  }
}

resource "aws_route_table" "backend-rt" {
  count  = length(var.backend_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block                = var.default_vpc_cidr_block
    vpc_peering_connection_id = var.peer_connection_id
  }
  route {
    cidr_block                = "0.0.0.0"
    gateway_id                = aws_nat_gateway.ngw[count.index].id

  }

  tags = {
    Name = "${var.env}-backend-rt${count.index+1}"
  }
}

resource "aws_route_table_association" "backend-rt-assoc" {
  count          = length(var.backend_subnets)
  subnet_id      = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend-rt[count.index].id
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "db-subnet${count.index+1}"
  }
}

resource "aws_route_table" "db-rt" {
  count  = length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block                = var.default_vpc_cidr_block
    vpc_peering_connection_id = var.peer_connection_id
  }
  route {
    cidr_block                = "0.0.0.0"
    gateway_id                = aws_nat_gateway.ngw[count.index].id

  }

  tags = {
    Name = "${var.env}-db-rt${count.index+1}"
  }
}

resource "aws_route_table_association" "db-rt-assoc" {
  count          = length(var.db_subnets)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db-rt[count.index].id
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "public-subnet${count.index+1}"
  }
}

resource "aws_route_table" "public-rt" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block                = var.default_vpc_cidr_block
    vpc_peering_connection_id = var.peer_connection_id
  }
  route {
    cidr_block                = "0.0.0.0"
    gateway_id                = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "${var.env}-public-rt${count.index+1}"
  }
}
resource "aws_route_table_association" "public-rt-assoc" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-rt[count.index].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "eip" {
  count    = length(var.public_subnets)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.env}-ngw${count.index+1}"
  }
}

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = var.default_vpc_id
  vpc_id      = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "peer connection between ${var.env} vpc to default vpc"
  }
}

resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = var.default_vpc_cidr_block
  vpc_peering_connection_id = var.peer_connection_id
}

resource "aws_route" "default" {
  route_table_id         = var.default_route_table_id
  destination_cidr_block = var.dev_vpc_cidr_block
  vpc_peering_connection_id = var.peer_connection_id
}