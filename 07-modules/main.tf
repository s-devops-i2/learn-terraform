module "ec2" {
  source = "./07-modules/app"
  instance_type = var.instance_type
  sg = var.sg
}


