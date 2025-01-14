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

  tags = {
    Name = "${var.env}-frontend-rt${count.index+1}"
  }
}

resource "aws_route_table_association" "frontend-rt-assoc" {
  count          = length(var.frontend_subnets)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend-rt[count.index].id
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