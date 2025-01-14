module "vpc" {
  source = "./modules/vpc"

  env  = var.env
  subnet_cidr_block = var.subnet_cidr_block
}