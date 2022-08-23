output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "subnets" {
  value = aws_subnet.public_subnet
}

output "region" {
  value = var.aws_region
}
