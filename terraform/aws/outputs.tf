/*
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The vpc id"
}

output "vpc_cidr_block" {
  value       = aws_vpc.main.cidr_block
  description = "The vpc cidr block"
}

output "vpc_region" {
  value       = aws_vpc.main.region
  description = "The vpc region"
}

output "vpc_tags" {
  value       = aws_vpc.main.tags
  description = "The vpc tags"
}
*/
output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnet[*].id
}

##output "sg_group" {
##  value = aws_security_group.sg_group.id
##}

output "my_vpc" {
  value = aws_vpc.main.id
}
