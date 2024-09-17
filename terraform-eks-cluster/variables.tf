variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "EKS version"
  type        = string
  default     = "1.21"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
}

variable "key_name" {
  description = "EC2 Key pair name for worker nodes"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for Terraform backend"
  type        = string
}

variable "dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}
