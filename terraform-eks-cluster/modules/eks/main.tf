module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type    = var.instance_type
      key_name         = var.key_name
      iam_role_arn     = module.iam.eks_worker_role_arn
    }
  }

  cluster_iam_role_arn = module.iam.eks_cluster_role_arn

  tags = {
    Name = var.cluster_name
  }
}
