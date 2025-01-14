module "vpc" {
  source = "./modules/vpc"

  env               = var.env
  subnet_cidr_block = var.subnet_cidr_block
  default_vpic_id   = var.default_vpic_id
}