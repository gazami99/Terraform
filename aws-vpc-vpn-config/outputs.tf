output "vpc_info" {
  value = module.vpc.vpc_information
}

output "aws_profile_name" {
  value = local.aws_profile 
}

output "eks_name" {
  value = local.eks_name 
}

output "hostname" {
  value = local.hostname 
}

output "hostname_vpc" {
  value = local.hostname_vpc 
}

output "num_azs_count" {

  value = local.num_azs_selected
}

output "vpn_security_group_id" {

  value = module.vpn.vpn_security_group_id
}