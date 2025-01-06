# Create a VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Data source for Availability Zones
data "aws_availability_zones" "available" {}

# Create Subnets
resource "aws_subnet" "eks_subnet" {
  count               = length(var.subnet_cidr_blocks)
  vpc_id              = aws_vpc.eks_vpc.id
  cidr_block          = var.subnet_cidr_blocks[count.index]
  availability_zone   = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.cluster_name}-subnet-${count.index}"
  }
}