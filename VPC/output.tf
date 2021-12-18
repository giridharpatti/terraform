output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.shoppingcart-test.id
}
output "internet_gateway" {
  description = "The ID of the igw"
  value       = aws_internet_gateway.gw.id
}