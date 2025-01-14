output "frontend_subnets" {
  value = aws_subnet.frontend.*.id
}
output "vpc_id" {
  value = aws_vpc.main.id
}
