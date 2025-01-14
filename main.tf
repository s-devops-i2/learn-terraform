module "vpc" {
  source = "./modules/vpc"

  env                     = var.env
  subnet_cidr_block       = var.subnet_cidr_block
  default_vpc_id         = var.default_vpc_id
  default_route_table_id      = var.default_route_table_id
  default_vpc_cidr_block  = var.default_vpc_cidr_block
  dev_vpc_cidr_block      = var.dev_vpc_cidr_block
  peer_connection_id      = var.peer_connection_id
}