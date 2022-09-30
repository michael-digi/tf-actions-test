terraform {
  required_version = ">=0.12.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
}

resource "aws_vpc" "primary_vpc" {
  cidr_block = var.vpc_primary_cidr

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "primary-${var.env}-${var.region}"
    Env = var.env
    Region = var.region
  }
}

# Create the private subnets for the public/private pairs
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.primary_vpc.id
  count             = length(var.public_private_subnet_pairs)
  cidr_block        = lookup(var.public_private_subnet_pairs[count.index], "cidr")
  availability_zone = lookup(var.public_private_subnet_pairs[count.index], "az")

  tags = {
    Name = "Private Subnet (${lookup(var.public_private_subnet_pairs[count.index], "az")})"
    Tier = "Private Subnets"
    Vpc  = "primary-${var.env}-${var.region}"
    Env = var.env
    Region = var.region
  }
}

# Create the public subnets for the public/private pairs
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.primary_vpc.id
  count             = length(var.public_private_subnet_pairs)
  cidr_block        = lookup(var.public_private_subnet_pairs[count.index], "public_cidr")
  availability_zone = lookup(var.public_private_subnet_pairs[count.index], "az")

  tags = {
    Name = "Public Subnet (${lookup(var.public_private_subnet_pairs[count.index], "az")})"
    Tier = "Public Subnets"
    Vpc  = "primary-${var.env}-${var.region}"
    Env = var.env
    Region = var.region
  }
}

# Create primary IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "IGW for public subnets"
    Env = var.env
    Region = var.region
  }
}

# Create the EIP for the nat gateway first.
resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = "NAT EIP"
    Env = var.env
    Region = var.region
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.nat_ip.id
  depends_on    = [aws_eip.nat_ip]

  tags = {
    Name = "NAT Gateway for private subnets"
    Env = var.env
    Region = var.region
  }
}
