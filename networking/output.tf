output "vpc_cidr" {
  value = aws_vpc.vpc.id
}

output "vpc_public_subnet" {
  value = aws_subnet.vpc_public_subnet.*.id
}

output "vpc_output_public_subnet_cidr_block" {
  value = aws_subnet.vpc_public_subnet.*.cidr_block
}
