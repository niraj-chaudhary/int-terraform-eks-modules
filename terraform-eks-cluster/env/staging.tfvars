vpc_name           = "staging-vpc"
cidr_block         = "10.1.0.0/16"
public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
azs                = ["us-east-1a", "us-east-1b"]
cluster_name       = "staging-cluster"
desired_capacity   = 3
max_capacity       = 5
min_capacity       = 2
instance_type      = "t3.medium"
key_name           = "my-key-pair-staging"
aws_region         = "us-east-1"
s3_bucket          = "my-terraform-state-staging"
dynamodb_table     = "terraform-lock-table-staging"
