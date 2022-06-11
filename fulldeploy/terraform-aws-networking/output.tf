output "public_subnets" {
  value       = aws_subnet.public_subnets.*.id
  description = "Public subnet IDs configured with a cooresponding private subnet."
}

output "private_subnets" {
  value       = aws_subnet.private_subnets.*.id
  description = "Private subnet IDs configured with a corresponding public subnet."
}

output "vpc_id" {
  value       = aws_vpc.primary_vpc.id
  description = "The ID of the primary AWS VPC."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway."
}

output "nat_eip" {
  value       = aws_eip.nat_ip.public_ip
  description = "The Public IP of the NAT EIP."
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.nat_gw.id
  description = "The ID of the NAT Gateway."
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "The ID of the public route table."
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "The ID of the private route table."
}