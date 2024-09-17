module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  cidr_block          = var.cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                 = var.azs
}

module "iam" {
  source        = "./modules/iam"
  cluster_name  = var.cluster_name
}

module "eks_cluster" {
  source            = "./modules/eks"
  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_capacity  = var.desired_capacity
  max_capacity      = var.max_capacity
  min_capacity      = var.min_capacity
  instance_type     = var.instance_type
  cluster_iam_role_arn = module.iam.eks_cluster_role_arn
  worker_node_role_arn = module.iam.eks_worker_role_arn
}

module "network_policies" {
  source          = "./modules/network-policies"
  vpc_id          = module.vpc.vpc_id
}
