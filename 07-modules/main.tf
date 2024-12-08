module "ec2" {
  source = "./app"
  instance_type = var.instance_type
  sg = var.sg
}


