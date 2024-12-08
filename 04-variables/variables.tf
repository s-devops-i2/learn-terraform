variable "str" {
  default = "string value"
}
output "str_print" {
  value = var.str
}

variable "list" {
  default = [1,2,3,4]
}
output "list_print" {
  value = var.list
}
output "list_print1" {
  value = var.list[3]
}

variable "map" {
  default = {
    name = {
      first_name = "Shuja"
      last_name  = "Shaikh"
    }
  }
}

output "map_print" {
  value = var.map
}