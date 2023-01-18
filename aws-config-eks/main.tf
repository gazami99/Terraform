
#------------------ locals for input
locals {

    vpc_name                  = "eks"
    eks_name                  = "eks_ctl"

    num_azs_selected          = 2

    kube_config               = "~/.kube/config"

    eks_instance_types        = ["t4g.large"]
    eks_ami_type              = "AL2_ARM_64"

    aws_config_path           = "~/.aws/config"
    aws_credentials_path      = "~/.aws/credentials"
    aws_profile               = "user1"
}

provider "aws" {

    shared_config_files      = [pathexpand(local.aws_config_path)]
    shared_credentials_files = [pathexpand(local.aws_credentials_path)]

    profile                  = local.aws_profile
}


# ------------------------------------------------- data

#----------------------------------------- module
module "vpc" {

    source                  = "./vpc"
    name                    = local.vpc_name
    azs_selected            = local.num_azs_selected     # max -> the number of aws_availability_zones
    
    main_vpc_cidr           = "10.0.0.0/16"

    ## for EKS Tag
    additional_tags         =  {
        "kubernetes.io/cluster/${local.eks_name}" = "shared"
        }
    
}

module "eks" {

    source                  = "./eks"
    vpc_id                  = module.vpc.vpc_information.vpc.id
    eks_cluster_name        = local.eks_name

    instance_types          = local.eks_instance_types
    ami_type                = local.eks_ami_type

    max_size                = 2
    min_size                = 1
    desired_size            = 1

    depends_on = [
        module.vpc
    ] 

}

module "efs" {

    source                       = "./efs"
    vpc_id                       = module.vpc.vpc_information.vpc.id
    num_azs_selected             = local.num_azs_selected

    depends_on = [
        module.vpc,
        module.eks
    ]
}