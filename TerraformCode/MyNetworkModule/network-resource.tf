# Step 1 : Create VPC
resource "aws_vpc" "my_first_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Step 2 : Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_first_vpc.id
}

#  Step  3: Create elastic ip
resource "aws_eip" "my_eip" {
  domain = "vpc"  # Explicitly specify that the EIP is for use in a VPC
  #"vpc" is deprecated
  #vpc = true  
}


#  Step 4 : Create Nat Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.vpc_subnets["public"].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my_igw]
}

# Step 5: Create Public & Private Route Table
resource "aws_route_table" "route_tables" {
  count = 2
  vpc_id = aws_vpc.my_first_vpc.id

}

# Step 6 : Create Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route_tables[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}
# Step 7 : Create NAT Gateway Route
resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.route_tables[1].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}


# Step 8 : Create Public & Private Subnets
resource "aws_subnet" "vpc_subnets" {              
for_each = { for subnet in var.subnets_details : subnet.name => subnet }
  vpc_id            = aws_vpc.my_first_vpc.id
  cidr_block        = each.value.cidr
}

# Step 9 : Attach Route Tables to Subnets
resource "aws_route_table_association" "subnets_association" {
  count = length(var.subnets_details)
                                       # to get name of each subnet acoordings to count-index
  subnet_id      = aws_subnet.vpc_subnets[var.subnets_details[count.index].name].id
  route_table_id = count.index < 2 ? aws_route_table.route_tables[0].id : aws_route_table.route_tables[1].id
}


