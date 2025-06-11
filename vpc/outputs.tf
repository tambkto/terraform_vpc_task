output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "aws_subnet" {
  value = aws_subnet.public_subnet.id
}
output "aws_route_table" {
  value = aws_route_table.public_route_table.id
}