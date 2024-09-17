terraform {
  backend "s3" {
    bucket         = var.s3_bucket
    key            = "terraform/eks-cluster/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table
  }
}
