resource "aws_instance" "front" {
  count =  5
  ami           = data.aws_instance.private_ip.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-08f41a3b66746e56a"]
}
