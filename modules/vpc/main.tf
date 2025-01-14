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
