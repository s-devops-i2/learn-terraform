variable "instance_type" {
  default = "t3.micro"
}
variable "instance_types" {
  default = {
    frontend = {
    instance_type = "t3.micro"
    }
    backend = {
      instance_type = "t3.small"

    }
    mysql = {
      instance_type = "t3.micro"
    }
  }
}
