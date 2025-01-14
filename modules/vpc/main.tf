resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/24"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "${var.env}-subnet"
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
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = var.default_vpc_cidr_block
  vpc_peering_connection_id = var.peer_connection_id
}

resource "aws_route" "default" {
  route_table_id         = var.dev_route_table_id
  destination_cidr_block = var.dev_vpc_cidr_block
  vpc_peering_connection_id = var.peer_connection_id
}