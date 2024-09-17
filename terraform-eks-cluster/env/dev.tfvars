vpc_name           = "dev-vpc"
cidr_block         = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs                = ["us-east-1a", "us-east-1b"]
cluster_name       = "dev-cluster"
desired_capacity   = 2
max_capacity       = 3
min_capacity       = 1
instance_type      = "t3.medium"
key_name           = "my-key-pair-dev"
aws_region         = "us-east-1"
s3_bucket          = "my-terraform-state-dev"
dynamodb_table     = "terraform-lock-table-dev"
