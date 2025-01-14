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
  peer_vpc_id = var.default_vpic_id
  vpc_id      = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "peer connection between ${var.env} vpc to default vpc"
  }
}