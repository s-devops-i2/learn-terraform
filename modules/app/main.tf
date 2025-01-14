resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.sg_id

  tags = {
    Name = "${var.env}-frontend"
  }
}