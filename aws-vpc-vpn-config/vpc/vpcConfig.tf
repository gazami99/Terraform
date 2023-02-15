
locals {
    
    # if input azs_count exceeds  "aws_availability_zones"  -> select length
    azs_count               =   min(length(data.aws_availability_zones.aws_azs.names), var.azs_selected)
    azs                     =   [for i in range(local.azs_count) : data.aws_availability_zones.aws_azs.names[i]]

    subnet_cidrs            =   chunklist([for bit_num in range(local.azs_count*2) : cidrsubnet(var.main_vpc_cidr,8,bit_num+1)], local.azs_count)

    public_subnet_cidrs     =   local.subnet_cidrs[0]
    private_subnet_cidrs    =   local.subnet_cidrs[1]

}


#vpc config

resource "aws_vpc" "myvpc" {

    cidr_block  = var.main_vpc_cidr
    instance_tenancy = "default"

    # required for eks 
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.name}-vpc"
    }
}

resource "aws_subnet" "public_subnets" {

    count      = local.azs_count
    vpc_id = aws_vpc.myvpc.id
    cidr_block = element(local.public_subnet_cidrs, count.index)
    availability_zone = element(local.azs, count.index)

    tags = {
        Name = "Public_Subnet_${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnets" {

    count      = local.azs_count
    vpc_id     = aws_vpc.myvpc.id
    cidr_block = element(local.private_subnet_cidrs, count.index)
    availability_zone = element(local.azs, count.index)

    tags = merge(
        var.additional_tags,
        {
            Name = "Private_Subnet_${count.index + 1}"
        },
  )
}

resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    
    vpc_id =  aws_vpc.myvpc.id               # vpc_id will be generated after we create VPC
}

resource "aws_eip" "nat_eip" {

    count = local.azs_count
    vpc   = true
}

resource "aws_nat_gateway" "NATgw" {

    count               = local.azs_count
    connectivity_type   = "public"

    allocation_id       = element(aws_eip.nat_eip[*].id, count.index)
    subnet_id           = element(aws_subnet.public_subnets[*].id, count.index)
    
    depends_on = [
        aws_eip.nat_eip
    ]
 }

# # Route table for public Subnet 

resource "aws_route_table" "PublicRT" {
    
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = var.all_cidr  # Traffic from Public Subnet reaches Internet via Internet Gateway
        gateway_id = aws_internet_gateway.IGW.id
    }
}

# # Route table for Private Subnet

resource "aws_route_table" "PrivateRT" {

    count      = local.azs_count
    vpc_id =    aws_vpc.myvpc.id
    route {
        cidr_block = var.all_cidr  # Traffic from Private Subnet reaches Internet via NAT Gateway
        nat_gateway_id = element(aws_nat_gateway.NATgw[*].id,count.index) # Natgw located below
    }
}

#  #Route table Association with Public Subnet's

 resource "aws_route_table_association" "PublicRTassociation" {

    count           = local.azs_count
    subnet_id       = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id  = aws_route_table.PublicRT.id
 }

# #Route table Association with Private Subnet's

 resource "aws_route_table_association" "PrivateRTassociation" {

    count           = local.azs_count
    subnet_id       = element(aws_subnet.private_subnets[*].id, count.index)
    route_table_id  = element(aws_route_table.PrivateRT[*].id,count.index)
}

