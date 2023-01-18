output "vpc_info" {
  value = module.vpc.vpc_information
}

output "eks_info" {
  value = module.eks.eks_information
}

output "efs_info" {
  value = module.efs.eks_information
}

output "aws_profile_name" {
  value = local.aws_profile 
}