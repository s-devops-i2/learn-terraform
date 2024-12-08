resource "aws_instance" "frontend" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = var.instance_type
  vpc_security_group_ids = [var.sg]
}
