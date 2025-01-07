variable "aws_region" {
  description = "AWS region for the resources"
  default  = us-east-1
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default = 10.0.0.0/16
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
    default  = us-east-1
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default = ["10.0.1.0/24" , "10.0.2.0/24"]
}