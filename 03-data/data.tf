resource "aws_instance" "frontend" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-08f41a3b66746e56a"]
}
data "aws_instance" "private_ip" {
  instance_id = "i-01386c80f11cb4e68"

}
output "priv_ip" {
  value = data.aws_instance.private_ip.private_ip
}