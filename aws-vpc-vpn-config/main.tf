
#------------------ locals for input
locals {

    vpc_name                  = "vpc"
    eks_name                  = "eks-ctl"
    
    hostname                  = "gazami.click"
    hostname_vpc              = "server"

    num_azs_selected          = 2

    aws_config_path           = "~/.aws/config"
    aws_credentials_path      = "~/.aws/credentials"
    aws_profile               = "devops"

    main_vpc_cidr             = "10.0.0.0/16"
    client_cidr_block         = "10.1.0.0/22"
}


#--------------------- provider
provider "aws" {

    shared_config_files      = [pathexpand(local.aws_config_path)]
    shared_credentials_files = [pathexpand(local.aws_credentials_path)]

    profile                  = local.aws_profile
}



provider "null" {
  
}
#----------------------------------------- module
module "vpc" {

    source                  = "./vpc"
    name                    = local.vpc_name
    azs_selected            = local.num_azs_selected     # max -> the number of aws_availability_zones
    
    main_vpc_cidr           = local.main_vpc_cidr

    ## required for EKS Tag
    additional_tags         =  {
        "kubernetes.io/cluster/${local.eks_name}" = "shared"
        }
    
}

module "vpn" {

    source  = "./vpn(client)"

    hostname             = local.hostname_vpc
    client_cidr_block    = local.client_cidr_block

    private_subnet_cidrs = module.vpc.vpc_information.private_subnets.cidr_blocks
    vpc_id               = module.vpc.vpc_information.vpc.id
    count_private_subnet = local.num_azs_selected
    private_subnet_ids   = module.vpc.vpc_information.private_subnets.ids

    depends_on = [
      module.vpc
    ]
}