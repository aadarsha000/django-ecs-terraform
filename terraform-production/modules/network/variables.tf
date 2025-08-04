variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones for subnets"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region for VPC endpoints and flow logs"
  type        = string
}