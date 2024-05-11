output "M-subnets" {
    value = aws_subnet.vpc_subnets
    description = "List of private & public Subnets objects"
  
}

output "M-vpc_id" {

    value = aws_vpc.my_first_vpc.id
    description = "VPC id"
  
}

output "M-vpc_cidr_block" {
     value =  aws_vpc.my_first_vpc.cidr_block
     description = "VPC Cidr"
}
