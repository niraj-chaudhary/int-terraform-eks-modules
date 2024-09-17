# Providers
provider "aws" {
  region = "us-west-2"  # Specify your region
}

# Data sources to fetch existing VPC
data "aws_vpc" "existing_vpc" {
  # Filter to find the VPC based on tag or ID
  filter {
    name   = "tag:Name"
    values = ["your-vpc-name"]  # Replace with your VPC name
  }
}

# Data sources to fetch existing subnets
data "aws_subnet_ids" "existing_subnets" {
  vpc_id = data.aws_vpc.existing_vpc.id
}

# Optionally, you can fetch details of the subnets
data "aws_subnet" "public_subnet_1" {
  id = data.aws_subnet_ids.existing_subnets.ids[0]  # First subnet from the list
}
