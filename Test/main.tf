provider "aws" {
    region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support 
  enable_dns_hostnames           = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink
tags = {
  Name = "Main VPC-Demo"
}
}

# Create public subnets
resource "aws_subnet" "public" {
  #count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  #cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  #availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public_1-demo"
  }

# tags = merge(
#     var.additional_tags,
#     {
#       Name = format("PublicSubnet-%s", count.index)
#     } 
#   )
}

# Create private subnets
resource "aws_subnet" "private" {
  #count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  #cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
  cidr_block = var.private_cidr
  map_public_ip_on_launch = false
  #availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private_1-demo"
  }
}