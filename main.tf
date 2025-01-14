module "vpc" {
  source = "./modules/vpc"

  env                     = var.env
  subnet_cidr_block       = var.subnet_cidr_block
  default_vpc_id         = var.default_vpc_id
  default_route_table_id      = var.default_route_table_id
  default_vpc_cidr_block  = var.default_vpc_cidr_block
  dev_vpc_cidr_block      = var.dev_vpc_cidr_block
  peer_connection_id      = var.peer_connection_id
  frontend_subnets        = var.frontend_subnets
  backend_subnets         = var.backend_subnets
  db_subnets              = var.db_subnets
  availability_zone       = var.availability_zone
}

module "app" {
  source = "./modules/app"

  env           = var.env
  instance_type = var.instance_type
  sg_id         = var.sg_id
  component     = "frontend"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.frontend_subnets

}
